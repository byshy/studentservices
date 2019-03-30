import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Student {
  final int stdNum;
  final String stdName;
  final int stdLvl;
  final String stdMajor;

  Student({this.stdName, this.stdLvl, this.stdMajor, this.stdNum});

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      stdNum: json['stdno'],
      stdName: json['name'],
      stdLvl: json['lvl'],
      stdMajor: json['major'],
    );
  }

}

class StudentListItem extends StatelessWidget{
  final Student student;

  StudentListItem(this.student);

  Widget _buildTiles(Student root) {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0, left: 5.0, right: 5.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Wrap(
            children: <Widget>[
              Text(root.stdNum.toString(), style: TextStyle(fontSize: 20),),
              Text(root.stdName, style: TextStyle(fontSize: 20),),
              Text(root.stdMajor.toString(), style: TextStyle(fontSize: 20),),
              Text(root.stdLvl.toString(), style: TextStyle(fontSize: 20),),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildTiles(student);
  }

}

class StudentList {
  final List<Student> students;

  StudentList({this.students});

  factory StudentList.fromJson(List<dynamic> parsedJson) {
    List<Student> studentsList = parsedJson.map((i)=>Student.fromJson(i)).toList();

    return new StudentList(
      students: studentsList,
    );
  }

}