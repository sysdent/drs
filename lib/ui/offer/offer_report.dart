import 'package:flutter/material.dart';
import 'package:perforaya/model/fx/equipment_fx.dart';
import 'package:perforaya/model/fx/factor_fx.dart';
import 'package:perforaya/model/fx/fx.dart';
import 'package:perforaya/model/fx/offer_fx.dart';
import 'package:perforaya/model/fx/requirement_fx.dart';
import 'package:perforaya/model/fx/specification_fx.dart';
import 'package:perforaya/model/fx/system_fx.dart';
import 'package:perforaya/model/offer.dart';

class OfferReport extends StatelessWidget {
  List<Fx> _list;
  Offer offer;
  int type;

  OfferReport(this.offer, this._list, this.type);

  @override
  Widget build(BuildContext context) {
    List<Fx> list = _list.where((element) => element.type == type).toList();
    return Scaffold(
      appBar: AppBar(
        title: Text("Oferta - ${offer.company}"),
      ),
      body: ListView.builder(
          itemCount: list.length,
          itemBuilder: (BuildContext context, int position) {
            var item = list[position];
            bool isOffer = item.type == 1;
            bool isFactor = item.type == 2;
            bool isSystem = item.type == 3;
            bool isEquipment = item.type == 4;
            bool isSpecification = item.type == 5;
            bool isRequirement = item.type == 6;
            int padding = isOffer
                ? 0
                : isFactor
                    ? 1
                    : isSystem ? 2 : isEquipment ? 3 : isSpecification ? 4 : 5;
            String subtitle = isOffer
                ? "O"
                : isFactor
                    ? "F"
                    : isSystem
                        ? "S"
                        : isEquipment ? "Q" : isSpecification ? "E" : "R";
            return Card(
              elevation: 2.0,
              child: GestureDetector(
                child: ListTile(
                  title: Container(
                    child: Text(item.name),
                  ),
                  subtitle: Container(
                    child: isRequirement
                        ? Text("${item?.comment ?? ''}")
                        : Row(
                            children: [
                              Text(
                                "${item.percent}%",
                              ),
                            ],
                          ),
                    //padding: EdgeInsets.only(left: padding * 10.0),
                  ),
                  leading: CircleAvatar(
                    child: Text(
                      "${subtitle}",
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 30,
                          color: Colors.white),
                    ),
                    backgroundColor: isOffer
                        ? Colors.green
                        : isFactor
                            ? Colors.amber
                            : isSystem
                                ? Colors.blue
                                : isEquipment
                                    ? Colors.pinkAccent
                                    : isSpecification
                                        ? Colors.lightGreenAccent
                                        : Colors.black26,
                  ),
                  trailing: CircleAvatar(
                    child: Text("${item.value.round()}"),
                  ),
                ),
                onTap: () {
                  if (type < 6) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return OfferReport(offer, item.children, type + 1);
                    }));
                  }
                },
              ),
            );
          }),
    );
  }
}
