import 'package:flutter/material.dart';
import 'package:perforaya/model/factor.dart';
import 'package:perforaya/model/fx/offer_fx.dart';
import 'package:perforaya/model/fx/requirement_fx.dart';
import 'package:perforaya/model/offer.dart';
import 'package:perforaya/model/project.dart';
import 'package:perforaya/model/requirement.dart';
import 'package:perforaya/model/requirement_value.dart';
import 'package:perforaya/model/user.dart';
import 'package:perforaya/ui/factor/economic_factor_report.dart';
import 'package:perforaya/ui/offer/edit_offer.dart';
import 'package:perforaya/ui/searcher_template.dart';
import 'package:sqflite/sqflite.dart';

class OfferList extends SearcherTemplate<Offer> {
  OfferList(User user) : super(user);

  @override
  Future<List<Offer>> getList(Database db, String nameFilter) async {
    var list = await Offer.list(db, null);
    if (list.length > 0)
      list.add(Offer(-1, 0, "Factor económico", "Factor económico", "", "", "",
          "", "", "", "", ""));
    return Future.delayed(Duration(seconds: 0), () => list);
  }

  @override
  ListTile getListTile(Offer entityModel) {
    return ListTile(
      trailing: Container(
        child: entityModel.id > 0
            ? CircleAvatar(
                child: Text(
                  entityModel.id > 0
                      ? "${entityModel?.score?.round() ?? 0.0}"
                      : "",
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 16,
                      color: Colors.white),
                ),
                backgroundColor: Colors.blue,
              )
            : Text(""),
        margin: EdgeInsets.only(right: 5),
      ),
      title: Text(
        entityModel.drillName,
        style: TextStyle(
            fontWeight:
                entityModel.id > 0 ? FontWeight.normal : FontWeight.bold),
      ),
      subtitle: Text(
        entityModel.company,
      ),
    );
  }

  @override
  Future<Map<String, dynamic>> initEditView(Offer offer) async {
    Map<String, dynamic> map = new Map<String, dynamic>();
    var db = await dbHelper.database;
    if (offer != null && offer.id <= 0) {
      var list = await Offer.list(db, null);

      List<OfferFx> offersFx = [];

      for (Offer offer in list) {
        var offerFx = OfferFx(offer.id, offer.drillName, 0, "");
        var listByProject = await Factor.listByProject(db, offer.project);
        var economicFactor =
            listByProject.where((element) => element.type == ECONOMIC).toList();
        var rqs = await Requirement.listByProjectAndFactor(
            db, offer.project, economicFactor[0].id);
        var rqValues = await RequirementValue.listByProjectFactorAndOffer(
            db, offer.project, economicFactor[0].id, offer.id);
        offerFx.addChildren(rqValues.map((e) {
          Requirement rq =
              rqs.where((element) => element.id == e.requirement).toList()[0];
          var rqfx = RequirementFx(e.id, rq.label, e.value + .0, e.comment);
          rqfx.setValue(e.value + .0);

          return rqfx;
        }).toList());
        //if (offersFx.length > 0) {
        offersFx.add(offerFx);
        //}
      }
      map.putIfAbsent("offers", () => offersFx);
      return Future.delayed(Duration(seconds: 0), () => map);
    }
    var projects = await Project.list(db, null);
    map.putIfAbsent("projects", () => projects);
    return Future.delayed(Duration(seconds: 0), () => map);
  }

  Widget getEditScreen(Map<String, dynamic> params, Offer offer) {
    if (offer != null && offer.id <= 0) {
      return EconomicFactorReport(params["offers"]);
    }
    return EditOffer(params["projects"], offer);
  }

  @override
  Future<Offer> deleteItem(Offer offer) async {
    var db = await dbHelper.database;
    int rowsDeleted = await Offer.delete(db, offer);
    if (rowsDeleted != null && rowsDeleted > 0) {
      deleted = true;
      selectedIndex = -1;
      return Future.delayed(Duration(seconds: 0), () => offer);
    }
    return null;
  }
}
