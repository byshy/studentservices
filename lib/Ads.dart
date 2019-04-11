import 'package:flutter/material.dart';
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

class AdsRout extends StatelessWidget {
  AdsList list;

  Widget adsTile(context, index) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.only(
            top: 10.0, bottom: 10.0, left: 8.0, right: 8.0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(list.list[index].address,style: TextStyle(fontSize: 15.0)),
            ),
            Expanded(
              child: Text(list.list[index].dest,style: TextStyle(color: Colors.green, fontSize: 15.0)),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ads"),
      ),
      body: FutureBuilder<AdsList>(
          future: Networking().getAds(),
          builder: (ctxt, snap) {
            if (snap.hasData) {
              list = new AdsList(list: snap.data.list);

              if (list.list.isEmpty) {
                return Text("no data to be shown");
              }
              return Padding(
                padding: const EdgeInsets.only(top: 9.0),
                child: ListView.separated(
                  separatorBuilder: (context, index) => Divider(),
                  itemBuilder: adsTile,
                  itemCount: list.list.length,
                ),
              );
            } else if (snap.hasError) {
              return Text(snap.error);
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
          }),
    );
  }
}
