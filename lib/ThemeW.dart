import 'dart:io';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'data.dart';
import 'package:shared_preferences/shared_preferences.dart';
class ThemeW extends StatefulWidget {
  @override
  ThemeWState createState() => ThemeWState();

  const ThemeW({Key key}) : super(key: key);
}

class ThemeWState extends State<ThemeW> {
  AdmobInterstitial interstitialAd;
  @override
  void initState() {
    interstitialAd = AdmobInterstitial(
      adUnitId: getInterstitialAdUnitId(),
      listener: (AdmobAdEvent event, Map<String, dynamic> args) {
        if (event == AdmobAdEvent.closed) interstitialAd.load();
      },
    );
    interstitialAd.load();

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        backgroundColor: Colors.transparent,
    ),
    body: Container(
    decoration: new BoxDecoration(
    gradient: new LinearGradient(
    colors: [
    Colors.grey[100],
    Colors.grey[300],
    ],
    begin: const FractionalOffset(0.0, 1.0),
    end: const FractionalOffset(1.0, 0.0),
    stops: [0.0, 1.0],
    tileMode: TileMode.mirror),
    ),
    child: Container(
    margin: EdgeInsets.only(bottom: 50),

    child:GridView.count(
    crossAxisCount: 2,
    childAspectRatio: 1.0,
    padding: const EdgeInsets.all(4.0),
    mainAxisSpacing: 4.0,
    crossAxisSpacing: 4.0,

        children: images.map((String img) {
          return new GridTile(
              child:  SizedBox(
                  width: 200.0,
                  height: 800.0,
              child:  GestureDetector(
                  onTap: ()=>  {  setIndexBackground(images.indexOf(img)),  Navigator.pop(context,true),  },



            child: Card(
                elevation: 5,
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child:
                  Image.asset(
                    img,
                    gaplessPlayback: true,
                    fit: BoxFit.fill,
                  ),
                )
            ),
          )));

        }).toList()),
    )),
    );
  }
//  navigateTheme(BuildContext context,int index) {
//   // QuoteModel routeIndex = QuoteModel(index);
//
//    Navigator.push(
//      context,
//      MaterialPageRoute(
//        builder: (context) => Home(),
//        settings: RouteSettings(
//          arguments: routeIndex,
//        ),
//      ),
//    );
//  }
  setIndexBackground(int index) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'index_background';
    final value = index;
    prefs.setInt(key, value);
    loadAds ();
  }
  String getInterstitialAdUnitId() {
    if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/4411468910';
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/1033173712';
    }
    return null;
  }
  void loadAds () async
  {
    if (await interstitialAd.isLoaded)
      interstitialAd.show();
  }
}




