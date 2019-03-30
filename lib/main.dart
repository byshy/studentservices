import 'package:flutter/material.dart';
import 'package:studentservices/Agenda.dart';
import 'package:studentservices/Schedule.dart';

void main() => runApp(MyApp());

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
        home: Scaffold(
          body: DefaultTabController(
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
                    onPressed: () {},
                  ),
                ],
                bottom: TabBar(
                  labelColor: Colors.black,
                  indicatorColor: Colors.black,
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
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: Agenda(),
                  ),
                  ScheduleItem(),
                  ScheduleItem(),
                ],
              ),
              drawer: Drawer(
                child: ListView(
                  // Important: Remove any padding from the ListView.
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    DrawerHeader(
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
                      decoration: BoxDecoration(
                        color: Color(0xffdddddd),
                      ),
                    ),
                    ListTile(
                      title: Text('Item 1'),
                      onTap: () {
                        // Update the state of the app
                        // ...
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      title: Text('Item 2'),
                      onTap: () {
                        // Update the state of the app
                        // ...
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
          ),
        ));
  }
}
