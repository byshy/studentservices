import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:studentservices/DataBase.dart';
import 'package:studentservices/Networking.dart';

class Exams {
  List<ExamsItems> midEx;
  List<ExamsItems> finalEx;

  Exams({this.midEx, this.finalEx});

  factory Exams.fromJson(Map<String, dynamic> json) {
    var list = json['mid'] as List;
    List<ExamsItems> midExam = list.map((i) => ExamsItems.fromJson(i)).toList();

    var list2 = json['final'] as List;
    List<ExamsItems> finalExam =
        list2.map((i) => ExamsItems.fromJson(i)).toList();

    return new Exams(midEx: midExam, finalEx: finalExam);
  }
} //PODO

class ExamsItems {
  String subject;
  String date;
  String time;

  ExamsItems({this.subject, this.date, this.time});

  factory ExamsItems.fromJson(Map<String, dynamic> json) {
    return new ExamsItems(
        subject: json["subject"], date: json["date"], time: json["time"]);
  }
} //PODO

class ExamsRoute extends StatefulWidget {
  @override
  _ExamsRouteState createState() => _ExamsRouteState();
}

class _ExamsRouteState extends State<ExamsRoute> {
  List<ExamsItems> midEx;
  List<ExamsItems> finalEx;
  final dbHelper = DatabaseHelper.instance;
  bool connectionStatus = false;

  @override
  void initState() {
    super.initState();
    checkConnection();
  }

  @override
  Widget build(BuildContext context) {
    if (connectionStatus) {
      return FutureBuilder<Exams>(
        future: Networking().getExams(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Exams exams = snapshot.data;

            midEx = exams.midEx;
            finalEx = exams.finalEx;

            dbHelper.deleteAllExams();

            ExamsItems item = new ExamsItems();
            for(int i = 0; i < midEx.length; i++){
              item = midEx[i];
              _insertExams(item.subject, item.date, item.time, 0);
            }

            for(int i = 0; i < finalEx.length; i++){
              item = finalEx[i];
              _insertExams(item.subject, item.date, item.time, 0);
            }

            return _buildExamsItem();
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }

          return returnCircularLoader();
        },
      );
    } else {
      return _buildExamsItem();
    }
  }

  Widget _buildExamsItem() {
    return FutureBuilder<List>(
      future: dbHelper.queryAllExamsRows(),
      initialData: List(),
      builder: (context, snapshot) {
        if (snapshot.data.length != 0) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, int position) {
                final item = snapshot.data[position];
                return Card(
                  elevation: 2.0,
                  child: InkWell(
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Text("Subject ID:"),
                              ),
                              Expanded(
                                child: Text(item.row[0]),
                              )
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Text("Date"),
                              ),
                              Expanded(child: Text(item.row[1]))
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Text("Time"),
                              ),
                              Expanded(child: Text(item.row[2]))
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        } else if (snapshot.data.length == 0 && !connectionStatus) {
          return Text("no data to be shown");
        } else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }

        return returnCircularLoader();
      },
    );
  }

  void _insertExams(
    String subjectID,
    String date,
    String time,
    int isFinal,
  ) async {
    Map<String, dynamic> row = {
      DatabaseHelper.examsSubjectIDColumn: subjectID,
      DatabaseHelper.examsDateColumn: date,
      DatabaseHelper.examsTimeColumn: time,
      DatabaseHelper.examsIsFinalColumn: isFinal
    };
    await dbHelper.insertExams(row);
    print("inserted $subjectID");
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
