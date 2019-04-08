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

  Widget studentTiles() {
    return FutureBuilder<StudentInfo>(
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
            children: <Widget>[
              Text("Student Info",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text(student.stdNameAra),
              Text(student.stdNameEng),
              Text(student.stdNum.toString()),
              Text(student.stdDOB),
              Text(student.stdPOB),
              Text(student.stdAddress),
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
    );
  }

  Widget academicalTiles() {
    return FutureBuilder<AcademicalInfo>(
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
            children: <Widget>[
              Text("Academical Info",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text(info.college),
              Text(info.specialty),
              Text(info.lvl.toString()),
              Text(info.gpa.toString()),
              Text(info.planNo.toString()),
              Text(info.successHrs.toString()),
              Text(info.studyHrs.toString()),
              Text(info.remainingHrs.toString()),
              Text(info.balance.toString())
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Student Info"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[studentTiles(), academicalTiles()],
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
