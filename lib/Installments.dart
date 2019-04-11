import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:studentservices/Networking.dart';

class Installments {
  List<InstallmentsItem> items;

  Installments({this.items});

  factory Installments.fromJson(Map<String,dynamic> json){
    var list = json['installments'] as List;
    List<InstallmentsItem> installmentsList = list.map((i) => InstallmentsItem.fromJson(i)).toList();

    return new Installments(
      items: installmentsList
    );
  }
}

class InstallmentsItem {
  final String dueDate;
  final int amount;
  final int payed;

  InstallmentsItem({this.dueDate, this.amount, this.payed});

  factory InstallmentsItem.fromJson(Map<String, dynamic> json) {
    return new InstallmentsItem(
        dueDate: json["due_date"],
        amount: json["amount"],
        payed: json["payed"]);
  }
}

class InstallmentsRoute extends StatelessWidget {
  Installments installments;

  TextStyle style = TextStyle(fontSize: 15.0);

  Widget listTile(BuildContext context, int index){
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Card(
        elevation: 4.0,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(child: Text("dueDate", style: style)),
                  Expanded(child: Text(installments.items[index].dueDate, style: style)),
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(child: Text("amount", style: style)),
                  Expanded(child: Text(installments.items[index].amount.toString(), style: style)),
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(child: Text("payed", style: style)),
                  Expanded(child: Text(installments.items[index].payed.toString(), style: style)),
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(child: Text("remaining", style: style)),
                  Expanded(child: Text((installments.items[index].amount - installments.items[index].payed).toString(), style: style))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Installments"),
      ),
      body: FutureBuilder<Installments>(
        future: Networking().getInstallments(),
        builder: (context, snapshot){
          if (snapshot.hasData){
            installments = new Installments(
              items: snapshot.data.items
            );

            return ListView.builder(
              itemBuilder: listTile,
              itemCount: installments.items.length,
            );

          } else if (snapshot.hasError){
            return Text(snapshot.error.toString());
          }

          return Center(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(),
                ),
              ],
            ),
          );

        },
      ),
    );
  }

}
