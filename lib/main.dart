import 'package:flutter/material.dart';
import 'package:studentservices/Ads.dart';
import 'package:studentservices/Agenda.dart';
import 'package:studentservices/Exams.dart';
import 'package:studentservices/Installments.dart';
import 'package:studentservices/Marks.dart';
import 'package:studentservices/Schedule.dart';
import 'package:studentservices/Student.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(MyApp());

_launchURL() async {
  const url = 'https://idp.iugaza.edu.ps/idp/Authn/UserPassword';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Services',
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 1,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: new IconThemeData(color: Colors.black),
          title: Text(
            "Student Services",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.language),
              onPressed: () {
                _launchURL();
              },
            ),
          ],
          bottom: TabBar(
            labelColor: Colors.blue,
            indicatorColor: Colors.blue,
            unselectedLabelColor: Colors.black,
            tabs: [
              Tab(
                text: "Exams",
              ),
              Tab(
                text: "Schedual",
              ),
              Tab(
                text: "Marks",
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ExamsRoute(),
            ScheduleRoute(),
            MarksRoute(),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: FlatButton(
                  onPressed: () {
                    Route info = MaterialPageRoute(
                        builder: (context) => StudentRoute());
                    Navigator.pop(context);
                    Navigator.of(context).push(info);
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: Container(
                          color: Colors.blue,
                          width: 100.0,
                          height: 100.0,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text('Drawer Header'),
                      ),
                    ],
                  ),
                ),
                decoration: BoxDecoration(
                  color: Color(0xffdddddd),
                ),
              ),
              ListTile(
                title: Text('Agenda'),
                onTap: () {
                  Route agenda =
                      MaterialPageRoute(builder: (context) => AgendaRoute());
                  Navigator.pop(context);
                  Navigator.of(context).push(agenda);
                },
              ),
              ListTile(
                title: Text('Installments'),
                onTap: () {
                  Route installments = MaterialPageRoute(
                      builder: (context) => InstallmentsRoute());
                  Navigator.pop(context);
                  Navigator.of(context).push(installments);
                },
              ),
              ListTile(
                title: Text('Ads'),
                onTap: () {
                  Route ads = MaterialPageRoute(
                      builder: (context) => AdsRoute());
                  Navigator.pop(context);
                  Navigator.of(context).push(ads);
                },
              ),
              ListTile(
                title: Text('Study plan'),
                onTap: () {
                  // Update the state of the app
                  // ...
                },
              ),
              ListTile(
                title: Text('Financial record'),
                onTap: () {
                  // Update the state of the app
                  // ...
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
