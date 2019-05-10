import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studentservices/DataBase.dart';
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
} //PODO

class AgendaItem {
  final String title;
  final String date;

  AgendaItem(this.title, this.date);
} //PODO

class AgendaRoute extends StatefulWidget {
  @override
  _AgendaRouteState createState() => _AgendaRouteState();
}

class _AgendaRouteState extends State<AgendaRoute> with WidgetsBindingObserver {
  List<String> dates;
  List<AgendaItem> agendaItems;
  final dbHelper = DatabaseHelper.instance;
  bool connectionStatus = false;
  SharedPreferences prefs;
  String agendaLoaded = "agenda_loaded";
  AppLifecycleState _notification;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  new GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    initSharedPrefs();
    checkConnection();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if(_notification == AppLifecycleState.paused){
      setState(() {
        setIsNotLoaded(true);
      });
    }
    _notification = state;
  }

  final List<String> titles = [
    // list of titles
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Agenda"),
      ),
      body: Padding(
          padding: const EdgeInsets.only(bottom: 4.0), child: getInterface()),
    );
  }

  Widget getInterface() {
    if (connectionStatus && getIsNotLoaded()) {
      return FutureBuilder<AgendaContent>(
        future: Networking().getAgenda(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            dates = content(snapshot.data);

            dbHelper.deleteAllAgenda();

            for (int i = 0; i < titles.length; i++) {
              _insert(i, dates[i]);
            }

            return _buildAgendaItems();
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }

          return returnCircularLoader();
        },
      );
    } else {
      return _buildAgendaItems();
    }
  }

  Widget _buildAgendaItems() {
    return FutureBuilder<List>(
      future: dbHelper.queryAllAgendaRows(),
      initialData: List(),
      builder: (context, snapshot) {
        if (snapshot.data.length != 0) {
          return RefreshIndicator(
            key: _refreshIndicatorKey,
            onRefresh: _refresh,
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: ListView.separated(
                  itemBuilder: (context, position) {
                    final item = snapshot.data[position];
                    return InkWell(
                      onTap: () {},
                      // do nothing just used to comfort the user and inform that the app is not frozen
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 10.0, bottom: 10.0, left: 8.0, right: 8.0),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                                child: Text(titles[position],
                                    style: TextStyle(fontSize: 15.0))),
                            Expanded(
                                child: Text(item.row[1].toString(),
                                    style: TextStyle(
                                        color: Colors.green, fontSize: 15.0)))
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => Divider(),
                  itemCount: titles.length),
            ),
          );
        } else if (snapshot.data.length == 0 && !connectionStatus) {
          return Text("No data to be shown");
        } else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }

        setIsNotLoaded(false);
        return returnCircularLoader();
      },
    );
  }

  Future<Null> _refresh() {
    setIsNotLoaded(true);
    return Networking().getAgenda().then((_) {
      setState(() => {});
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

  void _insert(int id, String date) async {
    Map<String, dynamic> row = {
      DatabaseHelper.agendaIDColumn: id,
      DatabaseHelper.agendaDateColumn: date
    };
    await dbHelper.insertAgenda(row);
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

  void initSharedPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  void setIsNotLoaded(bool val) async {
    prefs.setBool(agendaLoaded,val);
  }

  bool getIsNotLoaded() {
    return prefs.getBool(agendaLoaded) ?? true;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

}
