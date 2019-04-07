import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:studentservices/Networking.dart';

class Schedule {
  List<Lecture> sat;
  List<Lecture> sun;
  List<Lecture> mon;
  List<Lecture> tue;
  List<Lecture> wed;

  Schedule({this.sat, this.sun, this.mon, this.tue, this.wed});

  factory Schedule.fromJson(Map<String, dynamic> json) {
    var satList = json['sat'] as List;
    List<Lecture> saturday = satList.map((i) => Lecture.fromJson(i)).toList();

    var sunList = json['sun'] as List;
    List<Lecture> sunday = sunList.map((i) => Lecture.fromJson(i)).toList();

    var monList = json['mon'] as List;
    List<Lecture> monday = monList.map((i) => Lecture.fromJson(i)).toList();

    var tueList = json['tue'] as List;
    List<Lecture> tuesday = tueList.map((i) => Lecture.fromJson(i)).toList();

    var wedList = json['wed'] as List;
    List<Lecture> wednesday = wedList.map((i) => Lecture.fromJson(i)).toList();

    return Schedule(
      sat: saturday,
      sun: sunday,
      mon: monday,
      tue: tuesday,
      wed: wednesday,
    );
  }
}

class Lecture {
  String lectureSubject;
  String lectureTime;

  Lecture({this.lectureSubject, this.lectureTime});

  factory Lecture.fromJson(Map<String, dynamic> json) {
    return Lecture(lectureSubject: json["subject"], lectureTime: json["time"]);
  }
}

//TODO think of more efficient way to present this data
class ScheduleItem extends StatelessWidget {
  Schedule s;

  Widget buildSat(BuildContext context, int index) {
    return Container(
      color: Color.fromRGBO(240, 240, 240, 1),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: (){},
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: <Widget>[
                Expanded(child: Text(s.sat[index].lectureSubject)),
                Expanded(child: Text(s.sat[index].lectureTime)),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget buildSun(BuildContext context, int index) {
    return Container(
      color: Color.fromRGBO(240, 240, 240, 1),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: (){},
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: <Widget>[
                Expanded(child: Text(s.sun[index].lectureSubject)),
                Expanded(child: Text(s.sun[index].lectureTime)),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget buildMon(BuildContext context, int index) {
    return Container(
      color: Color.fromRGBO(240, 240, 240, 1),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: (){},
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: <Widget>[
                Expanded(child: Text(s.mon[index].lectureSubject)),
                Expanded(child: Text(s.mon[index].lectureTime)),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget buildTue(BuildContext context, int index) {
    return Container(
      color: Color.fromRGBO(240, 240, 240, 1),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: (){},
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: <Widget>[
                Expanded(child: Text(s.tue[index].lectureSubject)),
                Expanded(child: Text(s.tue[index].lectureTime)),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget buildWed(BuildContext context, int index) {
    return Container(
      color: Color.fromRGBO(240, 240, 240, 1),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: (){},
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: <Widget>[
                Expanded(child: Text(s.wed[index].lectureSubject)),
                Expanded(child: Text(s.wed[index].lectureTime)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Schedule>(
      future: Networking().getSchedule(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          s = new Schedule(
              sat: snapshot.data.sat,
              sun: snapshot.data.sun,
              mon: snapshot.data.mon,
              tue: snapshot.data.tue,
              wed: snapshot.data.wed
          );

          return SingleChildScrollView(
            child: Column(
              children: <Widget>[
                ExpansionTile(
                  title: Text("Saturday"),
                  children: <Widget>[
                    ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: buildSat,
                      itemCount: s.sat.length,
                    ),
                  ],
                ),
                ExpansionTile(
                  title: Text("Sunday"),
                  children: <Widget>[
                    ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: buildSun,
                      itemCount: s.sun.length,
                    ),
                  ],
                ),
                ExpansionTile(
                  title: Text("Monday"),
                  children: <Widget>[
                    ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: buildMon,
                      itemCount: s.mon.length,
                    ),
                  ],
                ),
                ExpansionTile(
                  title: Text("Tuesday"),
                  children: <Widget>[
                    ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: buildTue,
                      itemCount: s.tue.length,
                    ),
                  ],
                ),
                ExpansionTile(
                  title: Text("Wednesday"),
                  children: <Widget>[
                    ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: buildWed,
                      itemCount: s.wed.length,
                    ),
                  ],
                ),
              ],
            ),
          );
        } else if (snapshot.hasError) {
          return Text("error");
        }

        return Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
          ],
        );
      },
    );
  }
}
