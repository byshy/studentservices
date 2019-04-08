import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:studentservices/Networking.dart';

class AgendaContent {
  final String registrationStart;
  final String registrationEnd;
  final String studyingStart;
  final String studyingEnd;
  final String additionStart;
  final String additionEnd;
  final String examsStart;
  final String examsEnd;
  final String dropoutEnd;

  AgendaContent(
      {this.registrationStart,
      this.registrationEnd,
      this.studyingStart,
      this.studyingEnd,
      this.additionStart,
      this.additionEnd,
      this.examsStart,
      this.examsEnd,
      this.dropoutEnd});

  factory AgendaContent.fromJson(Map<String, dynamic> json) {
    return AgendaContent(
        registrationStart: json["regs"],
        registrationEnd: json["rege"],
        studyingStart: json["studs"],
        studyingEnd: json["stude"],
        additionStart: json["adds"],
        additionEnd: json["adde"],
        examsStart: json["exams"],
        examsEnd: json["exame"],
        dropoutEnd: json["drope"]);
  }
}

class AgendaItem {
  final String title;
  final String date;

  AgendaItem(this.title, this.date);
}

class Agenda extends StatefulWidget {
  @override
  _AgendaState createState() => _AgendaState();
}

class _AgendaState extends State<Agenda> {
  List<String> dates;
  List<AgendaItem> agendaItems;

  final List<String> titles = [
    "Registration Start",
    "Registration End",
    "Studying Start",
    "Studying End",
    "Addition Start",
    "Addition End",
    "Exams Start",
    "Exams End",
    "Drop-out End"
  ];

  List<String> content(AgendaContent a) {
    List<String> res = new List<String>();

    res.add(a.registrationStart);
    res.add(a.registrationEnd);
    res.add(a.studyingStart);
    res.add(a.studyingEnd);
    res.add(a.additionStart);
    res.add(a.additionEnd);
    res.add(a.examsStart);
    res.add(a.examsEnd);
    res.add(a.dropoutEnd);

    return res;
  }

  List<AgendaItem> agenda() {
    List<AgendaItem> res = new List<AgendaItem>();

    for (var i = 0; i < titles.length; i++) {
      res.add(new AgendaItem(titles[i], dates[i]));
    }

    return res;
  }

  Widget _buildAgendaItems(BuildContext context, int index) {
    return Padding(
      padding: const EdgeInsets.only(top: 3.0, left: 5.0, right: 5.0),
      child: InkWell(
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.only(
              top: 10.0, bottom: 10.0, left: 8.0, right: 8.0),
          child: Row(
            children: <Widget>[
              Expanded(
                  child: Text(agendaItems[index].title,
                      style: TextStyle(fontSize: 15.0))),
              Expanded(
                  child: Text(agendaItems[index].date,
                      style: TextStyle(color: Colors.green, fontSize: 15.0)))
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
        title: Text("Agenda"),
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 4.0),
        child: FutureBuilder<AgendaContent>(
          future: Networking().getAgenda(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              dates = content(snapshot.data);
              agendaItems = agenda();
              return Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: ListView.separated(
                  separatorBuilder: (context, index) => Divider(),
                  itemBuilder: _buildAgendaItems,
                  itemCount: titles.length,
                ),
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
      ),
    );
  }
}
