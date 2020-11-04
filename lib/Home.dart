import 'dart:io';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:molhem/models/QuoteModel.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_extend/share_extend.dart';
import 'data.dart';
import 'ThemeW.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'helper/DatabaseProvider.dart';
import 'helper/LifecycleEventHandler.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class Home extends StatefulWidget {
  @override
  HomeState createState() => new HomeState();

  const Home({Key key}) : super(key: key);
}

class HomeState extends State<Home> {
  CarouselSlider carouselSlider;
  int _current = 0;
  List<String> quoteList = List();
  List<String> saidList = List();
  List<String> pinList = List();
  List mainList = List();
  String _message = '';

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  static int backgroundIndex;
  bool showAd = false;
  IconData iconData;
  AdmobInterstitial interstitialAd;

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  @override
  void initState() {
    super.initState();
    getMessage();

    // Firebase.initializeApp().whenComplete(() {
    //   print("completed");
    //   setState(() {});
    // });
   // var a = _firebaseMessaging.getToken().toString();

        _firebaseMessaging.getToken().then((token) => print("Token : "+token));

    interstitialAd = AdmobInterstitial(
    adUnitId: getInterstitialAdUnitId(),
    listener: (AdmobAdEvent event, Map<String, dynamic> args) {
    if (event == AdmobAdEvent.closed) interstitialAd.load();
    },
    );
    interstitialAd.load();

    WidgetsBinding.instance.addObserver(
    LifecycleEventHandler(resumeCallBack: () async => getIndex()));
    }

  void getMessage() {
    _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
          print('on message $message');
          setState(() => _message = message["notification"]["title"]);
        }, onResume: (Map<String, dynamic> message) async {
      print('on resume $message');
      setState(() => _message = message["notification"]["title"]);
    }, onLaunch: (Map<String, dynamic> message) async {
      print('on launch $message');
      setState(() => _message = message["notification"]["title"]);
    });
    _firebaseMessaging.requestNotificationPermissions();
  }

  @override
  Widget build(BuildContext context) {
    getIndex();


    // Navigator.pop(context);
    return LayoutBuilder(
        builder: (ctx, constraints) {
          final appBar = AppBar(
            centerTitle: true,
            title: Image.asset(
                'assets/textlogo.png', width: constraints.maxWidth * 0.2,
                height: constraints.maxHeight * 0.05),

            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.brush),
                color: Colors.white,
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => ThemeW()));
                },
              ),
            ],
          );
          return Scaffold(
              appBar: appBar,
              body: SafeArea(
                  child: Container(
                      padding: EdgeInsets.all(10.0),
                      height: (MediaQuery
                          .of(context)
                          .size
                          .height -
                          appBar.preferredSize.height -
                          MediaQuery
                              .of(context)
                              .padding
                              .top) *
                          1.2,
                      decoration: BoxDecoration(
                        gradient: new LinearGradient(
                            colors: [
                              Color(0xFFf2fbfc),
                              Color(0xFFa4ced4),
                            ],
                            begin: const FractionalOffset(0.0, 1.0),
                            end: const FractionalOffset(1.0, 0.0),
                            stops: [0.0, 1.0],
                            tileMode: TileMode.mirror),
                      ),


                      child: Column(
                          children: <Widget>[
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  AdmobBanner(
                                    adUnitId: getBannerAdUnitId(),
                                    adSize: AdmobBannerSize.BANNER,
                                  ),
                                ]),

                            Column(
                                mainAxisAlignment: MainAxisAlignment.center,

                                children: <Widget>[
                                  StreamBuilder<QuerySnapshot>(
                                      stream: Firestore.instance.collection(
                                          'quot')
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        if (!snapshot.hasData) {
                                          return Container(
                                              child: Center(
                                                  child: Text("Loading")));
                                        }

                                        mainList = snapshot.data.documents
                                            .map((
                                            DocumentSnapshot docSnapshot) {
                                          return docSnapshot.data.containsKey(
                                              'text');
                                        }).toList();

                                        snapshot.data.documents
                                            .map((
                                            DocumentSnapshot docSnapshot) {
                                          quoteList =
                                              docSnapshot.data['text'].cast<
                                                  String>();
                                        });

                                        snapshot.data.documents
                                            .map((
                                            DocumentSnapshot docSnapshot) {
                                          saidList =
                                              docSnapshot.data['said'].cast<
                                                  String>();
                                        });

                                        setList(quoteList);
                                        return SingleChildScrollView(
                                            child:
                                            carouselSlider = CarouselSlider(
                                              height: (MediaQuery
                                                  .of(context)
                                                  .size
                                                  .height -
                                                  appBar.preferredSize.height -
                                                  MediaQuery
                                                      .of(context)
                                                      .padding
                                                      .top) *
                                                  0.7,
                                              initialPage: 0,
                                              enlargeCenterPage: true,
                                              autoPlay: true,
                                              reverse: true,
                                              enableInfiniteScroll: false,
                                              autoPlayInterval: Duration(
                                                  seconds: 5),
                                              autoPlayAnimationDuration:
                                              Duration(milliseconds: 5000),
                                              pauseAutoPlayOnTouch: Duration(
                                                  seconds: 10),
                                              scrollDirection: Axis.horizontal,
                                              onPageChanged: (index) {
                                                setState(() {
                                                  _current = index;
                                                  if (_current % 7 == 0 &&
                                                      showAd == false) {
                                                    loadAds();
                                                    showAd = true;
                                                  }
                                                });
                                              },
                                              items: snapshot.data.documents
                                                  .map((
                                                  DocumentSnapshot document) {
                                                // Map getDocs = document.data as Map;
                                                isFavourite(
                                                    document.documentID);
                                                ScreenshotController screenshotController =
                                                ScreenshotController();

                                                return Builder(
                                                  builder: (
                                                      BuildContext context) {
                                                    return SingleChildScrollView(
                                                        child: Container(
                                                            height: (MediaQuery
                                                                .of(context)
                                                                .size
                                                                .height -
                                                                appBar
                                                                    .preferredSize
                                                                    .height -
                                                                MediaQuery
                                                                    .of(context)
                                                                    .padding
                                                                    .top) *
                                                                0.6,
                                                            width:
                                                            MediaQuery
                                                                .of(context)
                                                                .size
                                                                .width,
                                                            margin: EdgeInsets
                                                                .symmetric(
                                                                horizontal: 20.0),
                                                            decoration: BoxDecoration(
                                                              borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                  15),
                                                              image: DecorationImage(
                                                                image: AssetImage(
                                                                    images[backgroundIndex]),
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                            ),
                                                            child: Column(
                                                              mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                              children: <
                                                                  Widget>[
                                                                Container(
                                                                  height: constraints
                                                                      .maxHeight *
                                                                      0.05,
                                                                  decoration: BoxDecoration(
                                                                    borderRadius:
                                                                    new BorderRadius
                                                                        .only(
                                                                      topLeft:
                                                                      const Radius
                                                                          .circular(
                                                                          15.0),
                                                                      topRight:
                                                                      const Radius
                                                                          .circular(
                                                                          15.0),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  child: Screenshot(
                                                                    controller:
                                                                    screenshotController,
                                                                    child: Container(
                                                                      height: (MediaQuery
                                                                          .of(
                                                                          context)
                                                                          .size
                                                                          .height -
                                                                          appBar
                                                                              .preferredSize
                                                                              .height -
                                                                          MediaQuery
                                                                              .of(
                                                                              context)
                                                                              .padding
                                                                              .top) *
                                                                          0.7,
                                                                      width: double
                                                                          .infinity,
                                                                      decoration: BoxDecoration(
                                                                        image: DecorationImage(
                                                                          image: AssetImage(
                                                                              images[
                                                                              backgroundIndex]),
                                                                          fit: BoxFit
                                                                              .fill,
                                                                        ),
                                                                      ),
                                                                      child:
                                                                      Column(
                                                                          children: <
                                                                              Widget>[
                                                                            Padding(
                                                                              padding:
                                                                              EdgeInsets
                                                                                  .symmetric(
                                                                                  horizontal: 12.0,
                                                                                  vertical: 120.0),
                                                                              child: Text(
                                                                                  document
                                                                                      .data['text'],
                                                                                  textAlign:
                                                                                  TextAlign
                                                                                      .center,
                                                                                  style: TextStyle(
                                                                                      color:
                                                                                      Colors
                                                                                          .white,
                                                                                      fontSize: 20.0,
                                                                                      fontFamily:
                                                                                      "Tajawal")),
                                                                            ),
                                                                            Padding(
                                                                              padding:
                                                                              EdgeInsets
                                                                                  .symmetric(
                                                                                  horizontal: 12.0,
                                                                                  vertical: 12.0),
                                                                              child: Text(
                                                                                  (document
                                                                                      .data['said']),
                                                                                  style: TextStyle(
                                                                                      color:
                                                                                      Colors
                                                                                          .white,
                                                                                      fontSize: 18.0,
                                                                                      fontFamily:
                                                                                      "Tajawal")),
                                                                            ),
                                                                          ]),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Container(
                                                                  height: constraints
                                                                      .maxHeight *
                                                                      0.05,
                                                                  decoration: BoxDecoration(
                                                                    borderRadius:
                                                                    new BorderRadius
                                                                        .only(
                                                                      bottomLeft:
                                                                      const Radius
                                                                          .circular(
                                                                          15.0),
                                                                      bottomRight:
                                                                      const Radius
                                                                          .circular(
                                                                          15.0),
                                                                    ),
                                                                    gradient: new LinearGradient(
                                                                        colors: [
                                                                          Color(
                                                                              0x80000000),
                                                                          Color(
                                                                              0x00000000),
                                                                        ],
                                                                        begin:
                                                                        const FractionalOffset(
                                                                            1.0,
                                                                            1.0),
                                                                        end: const FractionalOffset(
                                                                            1.0,
                                                                            0.0),
                                                                        stops: [
                                                                          0.0,
                                                                          1.0
                                                                        ],
                                                                        tileMode: TileMode
                                                                            .clamp),
                                                                  ),
                                                                  child: Align(
                                                                    alignment:
                                                                    Alignment
                                                                        .bottomCenter,
                                                                    child: Row(
                                                                        children: <
                                                                            Widget>[
                                                                          IconButton(
                                                                            icon: Icon(
                                                                                Icons
                                                                                    .share),
                                                                            color: Colors
                                                                                .white,
                                                                            onPressed: () async {
                                                                              ScreenshotController
                                                                              shot =
                                                                                  screenshotController;
                                                                              shot
                                                                                  .capture(
                                                                                  pixelRatio: 2)
                                                                                  .then((
                                                                                  File
                                                                                  image) async {
                                                                                _showDialog(
                                                                                    (document
                                                                                        .data["text"]),
                                                                                    image
                                                                                        .path);
                                                                              })
                                                                                  .catchError((
                                                                                  onError) {
                                                                                print(
                                                                                    onError);
                                                                              });
                                                                            },
                                                                          ),
                                                                          FutureBuilder<
                                                                              bool>(
                                                                              future: isFavourite(
                                                                                  document
                                                                                      .documentID),
                                                                              builder: (
                                                                                  BuildContext
                                                                                  context,
                                                                                  AsyncSnapshot<
                                                                                      bool>
                                                                                  snapshot) {
                                                                                if (snapshot
                                                                                    .hasData) {
                                                                                  if (snapshot
                                                                                      .data ==
                                                                                      true)
                                                                                    iconData =
                                                                                        Icons
                                                                                            .favorite;
                                                                                  else
                                                                                    iconData =
                                                                                        Icons
                                                                                            .favorite_border;

                                                                                  return IconButton(
                                                                                      icon: Icon(
                                                                                          iconData),
                                                                                      color:
                                                                                      Colors
                                                                                          .white,
                                                                                      onPressed:
                                                                                          () async {
                                                                                        QuoteModel addToFav = QuoteModel(
                                                                                            id: document
                                                                                                .documentID
                                                                                                .toString(),
                                                                                            quote: (document
                                                                                                .data[
                                                                                            'text']),
                                                                                            said: (document
                                                                                                .data[
                                                                                            'said']));
                                                                                        if (snapshot
                                                                                            .data) {
                                                                                          await DatabaseProvider
                                                                                              .db
                                                                                              .deleteQuoteById(
                                                                                              document
                                                                                                  .documentID);
                                                                                        } else {
                                                                                          await DatabaseProvider
                                                                                              .db
                                                                                              .addQuote(
                                                                                              addToFav);
                                                                                        }

                                                                                        setState(() {
                                                                                          iconData =
                                                                                          snapshot
                                                                                              .data
                                                                                              ? Icons
                                                                                              .favorite_border
                                                                                              : iconData =
                                                                                              Icons
                                                                                                  .favorite;
                                                                                        });
                                                                                      });
                                                                                } else {
                                                                                  return new CircularProgressIndicator();
                                                                                }
                                                                              })
                                                                        ]),
                                                                  ),
                                                                )
                                                              ],
                                                            )));
                                                  },
                                                );
                                              }).toList(),
                                            ));
                                      }),

                                ])
                          ])
                  )));
        });
  }

  screenShot(String text, ScreenshotController screenshotController) {
    return Screenshot(
        controller: screenshotController,
        child: Container(
          child: Column(
            children: <Widget>[
              Image.asset(images[backgroundIndex]),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 70.0),
                child: Text(text,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontFamily: "Tajawal")),
              ),
            ],
          ),
        ));
  }

  navigateTheme(BuildContext context) {
    //  QuoteModel todo = QuoteModel(0);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ThemeW(),
//        settings: RouteSettings(
//          arguments: todo,
//        ),
      ),
    );
  }

  getIndex() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'index_background';
    final value = prefs.getInt(key) ?? 0;
    backgroundIndex = value;
    return backgroundIndex;
  }

  Future<bool> isFavourite(String id) async {
    var result = await DatabaseProvider.db.isExist(id);
    return result;
  }

  void loadAds() async {
    if (await interstitialAd.isLoaded) interstitialAd.show();
  }

  String getInterstitialAdUnitId() {
    if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/4411468910';
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-6139571964236523/9491860640';
    }
    return null;
  }

  void _showDialog(String text, String path) {
    // flutter defined function

    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("مشاركة الإقتباس"),
          content: new Text("هل تريد مشاركة الاقتباس صورة او نص ؟ "),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("نص"),
              onPressed: () {
                ShareExtend.share(text, "text");
              },
            ),
            new FlatButton(
              child: new Text("صورة"),
              onPressed: () {
                ShareExtend.share(path, "image");
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  setList(List<String> list) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'quote_list';
    final value = list;
    prefs.setStringList(key, value);
  }

  String getBannerAdUnitId() {
    if (Platform.isIOS) {
      return 'ca-app-pub-6139571964236523/4410071699';
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-6139571964236523/9729370656';
    }
    return null;
  }

  @override
  void dispose() {
    interstitialAd.dispose();
    super.dispose();
  }
}
