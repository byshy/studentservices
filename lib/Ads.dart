import 'dart:io';

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
} //PODO

class AdsList {
  List<Ads> list = new List();

  AdsList({this.list});

  factory AdsList.fromJson(List<dynamic> json) {
    List<Ads> adsList = json.map((i)=> Ads.fromJson(i)).toList();

    return new AdsList(list: adsList);
  }
} //PODO

class AdsRout extends StatefulWidget {
  @override
  _AdsRoutState createState() => _AdsRoutState();
}

class _AdsRoutState extends State<AdsRout> {
  final dbHelper = DatabaseHelper.instance;
  bool connectionStatus = false;

  @override
  void initState() {
    super.initState();
    checkConnection();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ads"),
      ),
      body: getInterface(),
    );
  }

  Widget getInterface() {
    if(connectionStatus){
      return FutureBuilder<AdsList>(
        future: Networking().getAds(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            dbHelper.deleteAllAds();

            for(int i = 0; i < snapshot.data.list.length; i++){
              Ads item = snapshot.data.list[i];
              _insert(item.address,item.dest);
            }

            return _buildAdsItems();

          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }

          return returnCircularLoader();
        },
      );
    }
    else {
      return _buildAdsItems();
    }

  }

  Widget _buildAdsItems() {
    return FutureBuilder<List>(
      future: dbHelper.queryAllAdsRows(),
      initialData: List(),
      builder: (context, snapshot) {
        if (snapshot.data.length != 0) {
          return Padding(
            padding: const EdgeInsets.only(top: 2.0),
            child: ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (ctxt, int position) {
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
                                      color: Colors.green, fontSize: 15.0)),
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
        } else if(snapshot.data.length == 0 && !connectionStatus){
          return Text("no data to be shown");
        } else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }

        return returnCircularLoader();

      },
    );
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

  void _insert(String address, String destination) async {
    Map<String, dynamic> row = {
      DatabaseHelper.adsAddressColumn: address,
      DatabaseHelper.adsDestinationColumn: destination
    };
    await dbHelper.insertAds(row);
  }

  Widget returnCircularLoader(){
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

}
