import 'dart:io';

import 'package:flutter/material.dart';
import 'package:studentservices/DataBase.dart';
import 'package:studentservices/Networking.dart';
import 'package:studentservices/Subjects.dart';

class SubjectItem {
  final String name;
  final String code;
  final int midEx;
  final int finalEx;
  final int credits;

  SubjectItem({this.name, this.code, this.midEx, this.finalEx, this.credits});

  factory SubjectItem.fromJson(Map<String, dynamic> json) {
    return new SubjectItem(
        name: json["name"],
        code: json["code"],
        midEx: json["mid"],
        finalEx: json["final"],
        credits: json["credits"]);
  }
}

class SubjectsList {
  List<SubjectItem> list = new List();

  SubjectsList({this.list});

  factory SubjectsList.fromJson(List<dynamic> json) {
    List<SubjectItem> subjectsList =
        json.map((i) => SubjectItem.fromJson(i)).toList();

    return new SubjectsList(
      list: subjectsList,
    );
  }
}

class MarkItem {
  final String year;
  final int semester;
  final double gpa;
  final double cGpa;
  final SubjectsList subjectsList;

  MarkItem({this.year, this.semester, this.gpa, this.cGpa, this.subjectsList});

  factory MarkItem.fromJson(Map<String, dynamic> json) {
    return new MarkItem(
        year: json["year"],
        semester: json["semister"],
        gpa: json["gpa"].toDouble(),
        cGpa: json["cgpa"].toDouble(),
        subjectsList: SubjectsList.fromJson(json["subjects"]));
  }
}

class MarksList {
  List<MarkItem> list;

  MarksList({this.list});

  factory MarksList.fromJson(List<dynamic> json) {
    List<MarkItem> marks = json.map((i) => MarkItem.fromJson(i)).toList();

    return new MarksList(list: marks);
  }
}

class MarksRoute extends StatefulWidget {
  @override
  _MarksRouteState createState() => _MarksRouteState();
}

class _MarksRouteState extends State<MarksRoute> {
  MarksList marks;
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
      return FutureBuilder<MarksList>(
        future: Networking().getMarks(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            marks = new MarksList(list: snapshot.data.list);

            dbHelper.deleteAllMarks();

            dbHelper.deleteAllSubjects();

            for (int i = 0; i < snapshot.data.list.length; i++) {
              MarkItem marks = snapshot.data.list[i];
              SubjectsList item = marks.subjectsList;
              _insertMarks(i, marks.year, marks.semester, marks.gpa, marks.cGpa)
                  .then((int id) {
                for (int j = 0; j < item.list.length; j++) {
                  SubjectItem subject = item.list[j];
                  _insertSubjects(id, subject.name, subject.code, subject.midEx,
                      subject.finalEx, subject.credits);
                }
              });
            }

            return _buildMarksItems();
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }

          return returnCircularLoader();
        },
      );
    } else {
      return _buildMarksItems();
    }
  }

  Widget _buildMarksItems() {
    return FutureBuilder<List>(
      future: dbHelper.queryAllMarksRows(),
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
                    onTap: () {
                      Route subjects = MaterialPageRoute(
                          builder: (context) => SubjectsRoute());
                      Navigator.of(context).push(subjects);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Text("Year"),
                              ),
                              Expanded(
                                child: Text(item.row[1]),
                              )
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Text("Semester"),
                              ),
                              Expanded(child: Text(item.row[2].toString()))
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Text("GPA"),
                              ),
                              Expanded(child: Text(item.row[3].toString())),
                              Expanded(
                                child: Text("CGPA"),
                              ),
                              Expanded(child: Text(item.row[4].toString()))
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

  Future<int> _insertMarks(
      int id, String year, int semester, double gpa, double cGpa) async {
    Map<String, dynamic> row = {
      DatabaseHelper.marksIDColumn: id,
      DatabaseHelper.marksYearColumn: year,
      DatabaseHelper.marksSemesterColumn: semester,
      DatabaseHelper.marksGPAColumn: gpa,
      DatabaseHelper.marksCGPAColumn: cGpa
    };
    int getId = await dbHelper.insertMarks(row);
    return getId;
  }

  void _insertSubjects(int marksID, String name, String code, int mid,
      int finalExam, int credits) async {
    Map<String, dynamic> row = {
      DatabaseHelper.subjectsMarksIDColumn: marksID,
      DatabaseHelper.subjectsNameColumn: name,
      DatabaseHelper.subjectsCodeColumn: code,
      DatabaseHelper.subjectsMidColumn: mid,
      DatabaseHelper.subjectsFinalColumn: finalExam,
      DatabaseHelper.subjectsCreditsColumn: credits
    };
    await dbHelper.insertSubjects(row);
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
