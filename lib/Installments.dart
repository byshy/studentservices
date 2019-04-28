import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:studentservices/DataBase.dart';
import 'package:studentservices/Networking.dart';

class Installments {
  List<InstallmentsItem> list;

  Installments({this.list});

  factory Installments.fromJson(List<dynamic> json) {
    List<InstallmentsItem> installmentsList =
        json.map((i) => InstallmentsItem.fromJson(i)).toList();

    return new Installments(list: installmentsList);
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

class InstallmentsRoute extends StatefulWidget {
  @override
  _InstallmentsRouteState createState() => _InstallmentsRouteState();
}

class _InstallmentsRouteState extends State<InstallmentsRoute> {
  final dbHelper = DatabaseHelper.instance;
  bool connectionStatus = false;

  TextStyle style = TextStyle(fontSize: 15.0);

  @override
  void initState() {
    super.initState();
    checkConnection();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Installments"),
      ),
      body: getInterface(),
    );
  }

  Widget getInterface() {
    if (connectionStatus) {
      return FutureBuilder<Installments>(
        future: Networking().getInstallments(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            dbHelper.deleteAllInstallments();

            for (int i = 0; i < snapshot.data.list.length; i++) {
              InstallmentsItem item = snapshot.data.list[i];
              _insert(i, item.dueDate, item.amount, item.payed);
            }

            return _buildInstallmentsItems();
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }

          return returnCircularLoader();
        },
      );
    } else {
      return _buildInstallmentsItems();
    }
  }

  Widget _buildInstallmentsItems() {
    return FutureBuilder<List>(
        future: dbHelper.queryAllInstallmentsRows(),
        initialData: List(),
        builder: (context, snapshot) {
          if (snapshot.data.length != 0) {
            return Padding(
              padding: const EdgeInsets.all(4.0),
              child: ListView.builder(
                itemBuilder: (context, position){
                  final item = snapshot.data[position];
                  return Card(
                    elevation: 4.0,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Expanded(child: Text("dueDate", style: style)),
                              Expanded(
                                  child: Text(item.row[1],
                                      style: style)),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(child: Text("amount", style: style)),
                              Expanded(
                                  child: Text(
                                      item.row[2].toString(),
                                      style: style)),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(child: Text("payed", style: style)),
                              Expanded(
                                  child: Text(
                                      item.row[3].toString(),
                                      style: style)),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(child: Text("remaining", style: style)),
                              Expanded(
                                  child: Text(
                                      (item.row[2] - item.row[3]).toString(),
                                      style: style))
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
                itemCount: snapshot.data.length,
              ),
            );
          } else if (snapshot.data.length == 0 && !connectionStatus) {
            return Text("no data to be shown");
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }

          return returnCircularLoader();
        });
  }

  Future checkConnection() async {
    bool res = false;
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        res = true;
      }
    } on SocketException catch (_) {}

    setState(() {
      connectionStatus = res;
    });
  }

  void _insert(int id, String dueDate, int amount, int payed) async {
    Map<String, dynamic> row = {
      DatabaseHelper.installmentsIDColumn: id,
      DatabaseHelper.installmentsDueDateColumn: dueDate,
      DatabaseHelper.installmentsAmountColumn: amount,
      DatabaseHelper.installmentsPayedColumn: payed
    };
    await dbHelper.insertInstallments(row);
  }

  Widget returnCircularLoader() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[CircularProgressIndicator()],
        ),
      ),
    );
  }
}
