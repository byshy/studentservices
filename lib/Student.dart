import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:studentservices/DataBase.dart';
import 'package:studentservices/Networking.dart';

class StudentInfo {
  final int stdNum;
  final String stdDOB; // Date of birth
  final String stdPOB; // Place of birth
  final String stdNameEng;
  final String stdNameAr;
  final String stdAddress;

  StudentInfo(
      {this.stdNum,
      this.stdDOB,
      this.stdPOB,
      this.stdNameEng,
      this.stdNameAr,
      this.stdAddress});

  factory StudentInfo.fromJson(Map<String, dynamic> json) {
    return StudentInfo(
      stdNum: json["id_no"],
      stdDOB: json["dob"],
      stdPOB: json["pob"],
      stdNameEng: json["name_eng"],
      stdNameAr: json["name_ara"],
      stdAddress: json["address"],
    );
  }
} //PODO

class AcademicalInfo {
  final String college;
  final double gpa;
  final String specialty;
  final int lvl;
  final int planNo;
  final int successHrs;
  final int studyHrs;
  final int remainingHrs;
  final double balance;

  AcademicalInfo(
      {this.college,
      this.gpa,
      this.specialty,
      this.lvl,
      this.planNo,
      this.successHrs,
      this.studyHrs,
      this.remainingHrs,
      this.balance});

  factory AcademicalInfo.fromJson(Map<String, dynamic> json) {
    return new AcademicalInfo(
      college: json["college"],
      gpa: json["gpa"],
      specialty: json["specialty"],
      lvl: json["lvl"],
      planNo: json["plan_no"],
      successHrs: json["success_hrs"],
      studyHrs: json["study_hrs"],
      remainingHrs: json["remaining_hrs"],
      balance: json["balance"],
    );
  }
} //PODO

class StudentRoute extends StatefulWidget {
  @override
  _StudentRouteState createState() => _StudentRouteState();
}

class _StudentRouteState extends State<StudentRoute> {
  StudentInfo student;
  AcademicalInfo info;
  final dbHelper = DatabaseHelper.instance;
  bool connectionStatus = false;

  @override
  void initState() {
    super.initState();
    checkConnection();
  }

  TextStyle style = TextStyle(fontSize: 15.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Student Info"),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Card(
                  elevation: 4.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 12.0, right: 12.0, left: 12.0, bottom: 6.0),
                        child: Text("Student Info",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20.0)),
                      ),
                      getStudentInfoInterface(),
                    ],
                  )),
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Card(
                    elevation: 4.0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 12.0, right: 12.0, left: 12.0, bottom: 6.0),
                          child: Text("Academical Info",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20.0)),
                        ),
                        getAcademicalInfoInterface(),
                      ],
                    )),
              )
            ],
          ),
        ));
  }

  Widget getStudentInfoInterface() {
    if (connectionStatus) {
      return FutureBuilder<StudentInfo>(
        future: Networking().getStudentInfo(),
        builder: (context, snapshot) {
          print("received ${snapshot.data}");
          if (snapshot.hasData) {
            student = snapshot.data;

            dbHelper.deleteAllStudentInfo();

            _insertStudentInfo(student.stdNum, student.stdDOB, student.stdPOB,
                student.stdNameEng, student.stdNameAr, student.stdAddress);

            return _buildStudentItem();
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }

          return returnCircularLoader();
        },
      );
    } else {
      return _buildStudentItem();
    }
  }

  Widget _buildStudentItem() {
    return FutureBuilder<List>(
      initialData: List(),
      future: dbHelper.queryAllStudentInfoRows(),
      builder: (context, snapshot) {
        if (snapshot.data.length != 0) {
          final item = snapshot.data[0];
          return Padding(
            padding: const EdgeInsets.fromLTRB(12.0, 0, 12.0, 12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(child: Text("Name (Arabic)", style: style)),
                    Expanded(child: Text(item.row[4], style: style))
                  ],
                ),
                Divider(),
                Row(
                  children: <Widget>[
                    Expanded(child: Text("Name", style: style)),
                    Expanded(child: Text(item.row[3], style: style))
                  ],
                ),
                Divider(),
                Row(
                  children: <Widget>[
                    Expanded(child: Text("Std. ID.", style: style)),
                    Expanded(child: Text(item.row[0].toString(), style: style))
                  ],
                ),
                Divider(),
                Row(
                  children: <Widget>[
                    Expanded(child: Text("Date of Birth", style: style)),
                    Expanded(child: Text(item.row[1], style: style))
                  ],
                ),
                Divider(),
                Row(
                  children: <Widget>[
                    Expanded(child: Text("Place of Birth", style: style)),
                    Expanded(child: Text(item.row[2], style: style))
                  ],
                ),
                Divider(),
                Row(
                  children: <Widget>[
                    Expanded(child: Text("Address", style: style)),
                    Expanded(child: Text(item.row[5], style: style))
                  ],
                ),
              ],
            ),
          );
        } else if (snapshot.data.length == 0 && !connectionStatus) {
          return Text("No data to be shown");
        } else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }

        return returnCircularLoader();
      },
    );
  }

  Widget getAcademicalInfoInterface() {
    if (connectionStatus) {
      return FutureBuilder<AcademicalInfo>(
        future: Networking().getAcademicalInfo(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            info = snapshot.data;

            dbHelper.deleteAllAcademicalInfo();

            _insertAcademicalInfo(
                info.college,
                info.gpa,
                info.specialty,
                info.lvl,
                info.planNo,
                info.successHrs,
                info.studyHrs,
                info.remainingHrs,
                info.balance);

            return _buildAcademicalTiles();
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }

          return returnCircularLoader();
        },
      );
    } else {
      return _buildAcademicalTiles();
    }
  }

  Widget _buildAcademicalTiles() {
    return FutureBuilder<List>(
      initialData: List(),
      future: dbHelper.queryAllAcademicalInfoRows(),
      builder: (context, snapshot) {
        if (snapshot.data.length != 0) {
          final item = snapshot.data[0];
          return Padding(
            padding: const EdgeInsets.fromLTRB(12.0, 0, 12.0, 12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(child: Text("College", style: style)),
                    Expanded(child: Text(item.row[0], style: style))
                  ],
                ),
                Divider(),
                Row(
                  children: <Widget>[
                    Expanded(child: Text("Specialty", style: style)),
                    Expanded(child: Text(item.row[2], style: style))
                  ],
                ),
                Divider(),
                Row(
                  children: <Widget>[
                    Expanded(child: Text("Level", style: style)),
                    Expanded(child: Text(item.row[3].toString(), style: style))
                  ],
                ),
                Divider(),
                Row(
                  children: <Widget>[
                    Expanded(child: Text("GPA", style: style)),
                    Expanded(child: Text(item.row[1].toString(), style: style))
                  ],
                ),
                Divider(),
                Row(
                  children: <Widget>[
                    Expanded(child: Text("Plan Number", style: style)),
                    Expanded(child: Text(item.row[4].toString(), style: style))
                  ],
                ),
                Divider(),
                Row(
                  children: <Widget>[
                    Expanded(child: Text("Success Hours", style: style)),
                    Expanded(child: Text(item.row[5].toString(), style: style))
                  ],
                ),
                Divider(),
                Row(
                  children: <Widget>[
                    Expanded(child: Text("Study Hours", style: style)),
                    Expanded(child: Text(item.row[6].toString(), style: style))
                  ],
                ),
                Divider(),
                Row(
                  children: <Widget>[
                    Expanded(child: Text("Remaining Hours", style: style)),
                    Expanded(child: Text(item.row[7].toString(), style: style))
                  ],
                ),
                Divider(),
                Row(
                  children: <Widget>[
                    Expanded(child: Text("Balance", style: style)),
                    Expanded(child: Text(item.row[8].toString(), style: style))
                  ],
                )
              ],
            ),
          );
        } else if (snapshot.data.length == 0 && !connectionStatus) {
          return Text("No data to be shown");
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

  void _insertStudentInfo(int number, String dob, String pob, String nameEng,
      String nameAr, String address) async {
    Map<String, dynamic> row = {
      DatabaseHelper.studentNumberColumn: number,
      DatabaseHelper.studentDoBColumn: dob,
      DatabaseHelper.studentPoBColumn: pob,
      DatabaseHelper.studentNameEngColumn: nameEng,
      DatabaseHelper.studentNameArColumn: nameAr,
      DatabaseHelper.studentAddressColumn: address,
    };
    await dbHelper.insertStudentInfo(row);
  }

  void _insertAcademicalInfo(
      String college,
      double gpa,
      String specialty,
      int lvl,
      int planNo,
      int succHrs,
      int studHrs,
      int remHrs,
      double balance) async {
    Map<String, dynamic> row = {
      DatabaseHelper.academicalCollegeColumn: college,
      DatabaseHelper.academicalGPAColumn: gpa,
      DatabaseHelper.academicalSpecialtyColumn: specialty,
      DatabaseHelper.academicalLvlColumn: lvl,
      DatabaseHelper.academicalPlanNoColumn: planNo,
      DatabaseHelper.academicalSuccessHrsColumn: succHrs,
      DatabaseHelper.academicalStudyHrsColumn: studHrs,
      DatabaseHelper.academicalRemainingHrsColumn: remHrs,
      DatabaseHelper.academicalBalanceColumn: balance,
    };
    await dbHelper.insertAcademicalInfo(row);
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
