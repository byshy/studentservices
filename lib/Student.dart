import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:studentservices/Networking.dart';

class StudentInfo {
  final int stdNum;
  final String stdDOB; // Date of birth
  final String stdPOB; // Place of birth
  final String stdNameEng;
  final String stdNameAra;
  final String stdAddress;

  StudentInfo(
      {this.stdNum,
      this.stdDOB,
      this.stdPOB,
      this.stdNameEng,
      this.stdNameAra,
      this.stdAddress});

  factory StudentInfo.fromJson(Map<String, dynamic> json) {
    return StudentInfo(
      stdNum: json["id_no"],
      stdDOB: json["dob"],
      stdPOB: json["pob"],
      stdNameEng: json["name_eng"],
      stdNameAra: json["name_ara"],
      stdAddress: json["address"],
    );
  }
}

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
}

class StudentListItem extends StatelessWidget {
  StudentInfo student;
  AcademicalInfo info;

  TextStyle style = TextStyle(fontSize: 15.0);

  Widget studentTiles() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12.0, 0, 12.0, 12.0),
      child: FutureBuilder<StudentInfo>(
        future: Networking().getStudentInfo(),
        builder: (context, snapshot) {
          print("received ${snapshot.data}");
          if (snapshot.hasData) {
            student = new StudentInfo(
                stdNameAra: snapshot.data.stdNameAra,
                stdNameEng: snapshot.data.stdNameEng,
                stdNum: snapshot.data.stdNum,
                stdDOB: snapshot.data.stdDOB,
                stdPOB: snapshot.data.stdPOB,
                stdAddress: snapshot.data.stdAddress);

            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(child: Text("Name (Arabic)", style: style)),
                    Expanded(child: Text(student.stdNameAra, style: style))
                  ],
                ),
                Divider(),
                Row(
                  children: <Widget>[
                    Expanded(child: Text("NAme", style: style)),
                    Expanded(child: Text(student.stdNameEng, style: style))
                  ],
                ),
                Divider(),
                Row(
                  children: <Widget>[
                    Expanded(child: Text("Std. ID.", style: style)),
                    Expanded(
                        child: Text(student.stdNum.toString(), style: style))
                  ],
                ),
                Divider(),
                Row(
                  children: <Widget>[
                    Expanded(child: Text("Date of Birth", style: style)),
                    Expanded(child: Text(student.stdDOB, style: style))
                  ],
                ),
                Divider(),
                Row(
                  children: <Widget>[
                    Expanded(child: Text("Place of Birth", style: style)),
                    Expanded(child: Text(student.stdPOB, style: style))
                  ],
                ),
                Divider(),
                Row(
                  children: <Widget>[
                    Expanded(child: Text("Address", style: style)),
                    Expanded(child: Text(student.stdAddress, style: style))
                  ],
                ),
              ],
            );
          } else if (snapshot.hasError) {
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

  Widget academicalTiles() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12.0, 0, 12.0, 12.0),
      child: FutureBuilder<AcademicalInfo>(
        future: Networking().getAcademicalInfo(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            info = new AcademicalInfo(
                college: snapshot.data.college,
                specialty: snapshot.data.specialty,
                lvl: snapshot.data.lvl,
                gpa: snapshot.data.gpa,
                planNo: snapshot.data.planNo,
                successHrs: snapshot.data.successHrs,
                studyHrs: snapshot.data.studyHrs,
                remainingHrs: snapshot.data.remainingHrs,
                balance: snapshot.data.balance);

            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(child: Text("College", style: style)),
                    Expanded(child: Text(info.college, style: style))
                  ],
                ),
                Divider(),
                Row(
                  children: <Widget>[
                    Expanded(child: Text("specialty", style: style)),
                    Expanded(child: Text(info.specialty, style: style))
                  ],
                ),
                Divider(),
                Row(
                  children: <Widget>[
                    Expanded(
                        child: Text("${info.lvl.toString()}", style: style)),
                    Expanded(child: Text(info.lvl.toString(), style: style))
                  ],
                ),
                Divider(),
                Row(
                  children: <Widget>[
                    Expanded(child: Text("gpa", style: style)),
                    Expanded(child: Text(info.gpa.toString(), style: style))
                  ],
                ),
                Divider(),
                Row(
                  children: <Widget>[
                    Expanded(child: Text("planNo", style: style)),
                    Expanded(child: Text(info.planNo.toString(), style: style))
                  ],
                ),
                Divider(),
                Row(
                  children: <Widget>[
                    Expanded(child: Text("successHrs", style: style)),
                    Expanded(
                        child: Text(info.successHrs.toString(), style: style))
                  ],
                ),
                Divider(),
                Row(
                  children: <Widget>[
                    Expanded(child: Text("studyHrs", style: style)),
                    Expanded(
                        child: Text(info.studyHrs.toString(), style: style))
                  ],
                ),
                Divider(),
                Row(
                  children: <Widget>[
                    Expanded(child: Text("remainingHrs", style: style)),
                    Expanded(
                        child: Text(info.remainingHrs.toString(), style: style))
                  ],
                ),
                Divider(),
                Row(
                  children: <Widget>[
                    Expanded(child: Text("balance", style: style)),
                    Expanded(child: Text(info.balance.toString(), style: style))
                  ],
                )
              ],
            );
          } else if (snapshot.hasError) {
            return Text("error");
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Student Info"),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 8.0,right: 8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Card(
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
                        studentTiles(),
                      ],
                    )),
              ),
              Padding(
                padding: const EdgeInsets.all(2.0),
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
                        academicalTiles(),
                      ],
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}

//TODO: support for multiple accounts
//
//class StudentList {
//  final List<Student> students;
//
//  StudentList({this.students});
//
//  factory StudentList.fromJson(List<dynamic> parsedJson) {
//    List<Student> studentsList =
//        parsedJson.map((i) => Student.fromJson(i)).toList();
//
//    return new StudentList(
//      students: studentsList,
//    );
//  }
//}
