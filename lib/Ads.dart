import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  void func(){
    print("hi");
  }

  factory AdsList.fromJson(List<dynamic> json) {
    List<Ads> adsList = json.map((i)=> Ads.fromJson(i)).toList();

    return new AdsList(list: adsList);
  }
} //PODO

class AdsRoute extends StatefulWidget {
  @override
  _AdsRouteState createState() => _AdsRouteState();
}

class _AdsRouteState extends State<AdsRoute> with WidgetsBindingObserver {
  final dbHelper = DatabaseHelper.instance;
  bool connectionStatus = false;
  SharedPreferences prefs;
  String adsLoaded = "ads_loaded";
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
    if(connectionStatus && getIsNotLoaded()){
      return FutureBuilder<AdsList>(
        future: Networking().getAds(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            makeFuture(snapshot.data);

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
          return RefreshIndicator(
            key: _refreshIndicatorKey,
            onRefresh: _refresh,
            child: Padding(
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
            ),
          );
        } else if(snapshot.data.length == 0 && !connectionStatus){
          return Text("no data to be shown");
        } else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }

        setIsNotLoaded(false);
        return returnCircularLoader();

      },
    );
  }

  Future<Null> _refresh() {
    setIsNotLoaded(false);
    return Networking().getAds().then((ads) {
      makeFuture(ads);
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

  void _insert(int id, String address, String destination) async {
    Map<String, dynamic> row = {
      DatabaseHelper.adsIDColumn: id,
      DatabaseHelper.adsAddressColumn: address,
      DatabaseHelper.adsDestinationColumn: destination
    };
    int result = await dbHelper.insertAds(row);
    print("inserted $result");
  }

  void makeFuture(AdsList list){
    dbHelper.deleteAllAds();

    for(int i = 0; i < list.list.length; i++){
      Ads item = list.list[i];
      _insert(i,item.address,item.dest);
    }
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

  void initSharedPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  void setIsNotLoaded(bool val) async {
    prefs.setBool(adsLoaded,val);
  }

  bool getIsNotLoaded(){
    return prefs.getBool(adsLoaded) ?? true;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

}
