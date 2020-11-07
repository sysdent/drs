import 'package:flutter/material.dart';
import 'package:perforaya/model/fx/offer_fx.dart';

class EconomicFactorReport extends StatelessWidget {
  List<OfferFx> offers;

  EconomicFactorReport(this.offers);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Factor económico"),
      ),
      body: ListView.builder(
        itemCount: offers.length,
        itemBuilder: (BuildContext context, int position) {
          var offer = offers[position];
          List<Row> rows = offer.children.map((e) => Row(
            children: [
              Text("${e.name}:", style: TextStyle(fontWeight: FontWeight.bold),),
              Expanded(child: Text(e.value.toString(), textAlign: TextAlign.right,),),
            ],
          ),).toList();
          return Card(
            elevation: 2,
            margin: EdgeInsets.all(10),
            child: Container(
              margin: EdgeInsets.all(10),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(4, 4, 4, 12),
                    child: Align(
                      alignment: Alignment.center,
                      child:
                          Text(offer.name, style: TextStyle(fontSize: 20)),
                    ),
                  ),
                  Container(
                    child: Column(
                      children: rows,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
