import 'package:flutter/material.dart';
import 'package:studentservices/DataBase.dart';
import 'package:studentservices/Networking.dart';

class Ads {
  final String address;
  final String dest;

  Ads({this.address, this.dest});

  factory Ads.fromJson(Map<String, dynamic> json) {
    return new Ads(address: json["address"], dest: json["dest"]);
  }
}

class AdsList {
  List<Ads> list = new List();

  AdsList({this.list});

  factory AdsList.fromJson(Map<String, dynamic> json) {
    var list = json['ads'] as List;
    List<Ads> adsList = list.map((i) => Ads.fromJson(i)).toList();

    return new AdsList(list: adsList);
  }
}

class AdsRout extends StatefulWidget {
  @override
  _AdsRoutState createState() => _AdsRoutState();
}

class _AdsRoutState extends State<AdsRout> {
  List<Map<String, dynamic>> list;

  AdsList adsList;

  final dbHelper = DatabaseHelper.instance;

  Widget buildContent(snapshot){
    return Padding(
      padding: const EdgeInsets.only(top: 2.0),
      child: ListView.builder(
        itemCount: snapshot.data.length,
        itemBuilder: (_, int position) {
          final item = snapshot.data[position];
          return Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 2.0, 8.0, 2.0),
            child: Card(
              elevation: 2.0,
              child: InkWell(
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(item.row[1].toString(),
                            style: TextStyle(fontSize: 15.0)),
                      ),
                      Expanded(
                        child: Text(item.row[2].toString(),
                            style: TextStyle(
                                color: Colors.green,
                                fontSize: 15.0)),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget builtInterface(){
    return FutureBuilder<List>(
      future: dbHelper.queryAllAdsRows(),
      initialData: List(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return buildContent(snapshot);
        } else if (snapshot.hasError)
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[CircularProgressIndicator()],
          );
      },
    );
  }

  Widget buildBody() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: dbHelper.queryAllAdsRows(),
      initialData: List(),
      builder: (ctxt, databaseSnapshot) {
        if (databaseSnapshot.data.length == 0) {
          list = databaseSnapshot.data; // came from the db
          print("the 1st print ${list.toString()}");
          // if its empty then fill it from api
          return FutureBuilder<AdsList>(
              future: Networking().getAds(),
              builder: (ctxt, snap) {
                print(snap.hasData);
                if (snap.hasData) {
                  adsList =
                      new AdsList(list: snap.data.list); // got data from api

                  print("the 2nd print ${adsList.list.toString()}");
                  for (int i = 0; i < adsList.list.length; i++) {
                    _insert(adsList.list[i].address, adsList.list[i].dest);
                  }

                  if (adsList.list.isEmpty) {
                    return Text("no data to be shown");
                  }

                  return builtInterface();

                } else if (snap.hasError) {
                  return Text(snap.error.toString());
                }

                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    CircularProgressIndicator(),
                  ],
                );
              });
        } else if (databaseSnapshot.hasData) {
          print("when snap has data");

          return builtInterface();


        } else if (databaseSnapshot.hasError) {
          print("when snap has error");
          return Text(databaseSnapshot.error);
        }

        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[CircularProgressIndicator()],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ads"),
      ),
      body: buildBody(),
    );
  }

  void _insert(String address, String destination) async {
    Map<String, dynamic> row = {
      DatabaseHelper.adsAddressColumn: address,
      DatabaseHelper.adsDestinationColumn: destination
    };
    final id = await dbHelper.insertAds(row);
    print('inserted row id: $id');
  }
}
