import 'package:flutter/material.dart';
import 'package:studentservices/Networking.dart';

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

class MarkItem {
  final String year;
  final int semester;
  final double gpa;
  final double cGpa;
  final List<SubjectItem> subjectsList;

  MarkItem({this.year, this.semester, this.gpa, this.cGpa, this.subjectsList});

  factory MarkItem.fromJson(Map<String, dynamic> json) {
    var list = json["subjects"] as List;
    List<SubjectItem> subjects = list.map((i) => SubjectItem.fromJson(i));

    return new MarkItem(
        year: json["year"],
        semester: json["semister"],
        gpa: json["gpa"],
        cGpa: json["cgpa"],
        subjectsList: subjects);
  }
}

class MarksList {
  List<MarkItem> marks;

  MarksList({this.marks});

  factory MarksList.fromJson(Map<String, dynamic> json) {
    var list = json["marks"] as List;
    List<MarkItem> marks = list.map((i) => MarkItem.fromJson(i));

    return new MarksList(marks: marks);
  }
}

class MarksRoute extends StatelessWidget {
  MarksList marks;

  Widget markTile(context, index) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Text(marks.marks[index].year),
            Text(marks.marks[index].semester.toString()),
            Text(marks.marks[index].gpa.toString()),
            Text(marks.marks[index].cGpa.toString()),
            Text(marks.marks[index].subjectsList.toString())
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<MarksList>(
      future: Networking().getMarks(),
      builder: (ctxt, snap) {
        if (snap.hasData) {
          marks = new MarksList(marks: snap.data.marks);

          return ListView.builder(
            itemBuilder: markTile,
            itemCount: marks.marks.length,
          );
        } else if (snap.hasError) {
          return Text(snap.error.toString());
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
}
