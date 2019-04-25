import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:studentservices/DataBase.dart';

class Subjects extends StatefulWidget {
  @override
  _SubjectsState createState() => _SubjectsState();
}

class _SubjectsState extends State<Subjects> {
  final dbHelper = DatabaseHelper.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Subgects"),
      ),
      body: FutureBuilder<List>(
        future: dbHelper.queryAllSubjectsRows(),
        initialData: List(),
        builder: (context, snapshot) {
          if (snapshot.data.length != 0) {
            return ListView.separated(
                itemBuilder: (context, position) {
                  final item = snapshot.data[position];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Text("name"),
                            ),
                            Expanded(
                              child: Text(item.row[2]),
                            )
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Text("code"),
                            ),
                            Expanded(
                              child: Text(item.row[3]),
                            )
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Text("mid exam"),
                            ),
                            Expanded(
                              child: Text(item.row[4].toString()),
                            )
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Text("final exam"),
                            ),
                            Expanded(
                              child: Text(item.row[5].toString()),
                            )
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Text("credits"),
                            ),
                            Expanded(
                              child: Text(item.row[6].toString()),
                            )
                          ],
                        )
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index) => Divider(),
                itemCount: snapshot.data.length);
          } else if (snapshot.data.length == 0) {
            return Text("No data to be shown");
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }

          return Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[CircularProgressIndicator()],
              ),
            ),
          );
        },
      ),
    );
  }
}
