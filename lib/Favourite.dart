import 'dart:io';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:molhem/helper/DatabaseProvider.dart';
import 'package:molhem/models/QuoteModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math' as math;

class Favourite extends StatefulWidget {
  @override
  FavouriteState createState() => FavouriteState();

  Favourite({Key key}) : super(key: key);
}

class FavouriteState extends State<Favourite> {
  List<QuoteModel> items = new List();

  Future<List<QuoteModel>> list = DatabaseProvider.db.getAllQuote();

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(
        decoration: BoxDecoration(
          gradient: new LinearGradient(
              colors: [
                Color(0xFFF9EFED),
                Color(0xFFE6C4BB),
              ],
              begin: const FractionalOffset(0.0, 1.0),
              end: const FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.mirror),
        ),

        child: Column(
            children: <Widget>[

              Container(
                margin: const EdgeInsets.only(top: 80),
                child: Text(
                  'إقتباساتك المفضلة',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 25.0,
                      fontFamily: "Tajawal",
              fontWeight: FontWeight.bold
                  ),

                ),

              ),
              Expanded  (
              child : FutureBuilder<List<QuoteModel>>(
                future: DatabaseProvider.db.getAllQuote(),
                builder:
                    (BuildContext context,
                    AsyncSnapshot<List<QuoteModel>> snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          QuoteModel item = snapshot.data[index];
                          return Dismissible(
                              key: UniqueKey(),
                              background: new Container(
                                margin: const EdgeInsets.only(
                                    top: 10.0, right: 20.0, left: 15.0),
                                color: Colors.red,
                              ),
                              onDismissed: (direction) {
                                DatabaseProvider.db.deleteQuoteById(item.id);
                              },
                              child: Card(
                                  semanticContainer: true,
                                  clipBehavior: Clip.antiAliasWithSaveLayer,

                                  elevation: 10,
                                  margin: const EdgeInsets.only(
                                      top: 10.0, right: 20.0, left: 15.0),
                                  child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 15.0),
                                      child: ListTile(
                                        title: Text(item.quote,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16.0,
                                              fontFamily: "Tajawal"

                                          ),

                                        ),
                                      ))));
                        });
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
              ),
              Column(

                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  AdmobBanner(
                    adUnitId: getBannerAdUnitId(),
                    adSize: AdmobBannerSize.BANNER,
                  ),
                ],
              ),
            ]),
      ),

    );
  }

  String getBannerAdUnitId() {
    if (Platform.isIOS) {
      return 'ca-app-pub-6139571964236523/4410071699';
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/6300978111';
    }
    return null;
  }
}
