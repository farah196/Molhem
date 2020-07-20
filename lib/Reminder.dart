import 'dart:async';
import 'dart:io';


import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:molhem/Home.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Reminder extends StatefulWidget {
  @override
  ReminderState createState() => ReminderState();

  const Reminder({Key key}) : super(key: key);
}

class ReminderState extends State<Reminder> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  String dropdownValue = '1';
  TimeOfDay selectedTime = TimeOfDay.now();
  String repeateTime = "حدد الوقت" ;

  @override
  void initState() {
    super.initState();
    getRepeateTime();
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var android = new AndroidInitializationSettings('@mipmap/launcher_icon');
    var iOS = new IOSInitializationSettings();
    if (Platform.isIOS) {
      _requestIOSPermission();
    }
    var initSetttings = new InitializationSettings(android, iOS);
    flutterLocalNotificationsPlugin.initialize(initSetttings,
        onSelectNotification: onSelectNotification);
  }

  Future onSelectNotification(String payload) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Home(),
//        settings: RouteSettings(
//          arguments: todo,
//        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    getRepeateTime();
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
          child:  Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'إعدادات التذكيرات',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 25.0,
                  fontFamily: "Tajawal",
                  fontWeight: FontWeight.bold
              ),

            ),
            Container(
                margin: const EdgeInsets.only(top: 10),
           child: Text(
              'إقتباس ملهم اليومي سيلهمك لإنجاز كل نجاح ، اختر الوقت الذي تفضل ارسال إقتباسك الملهم',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontFamily: "Tajawal",

              ),

            )
            ),
          ]),


    ),

    Expanded(

    child :  Container(
        margin: const EdgeInsets.only(top: 80),
    child : Column(

    children: <Widget>[

    Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Container(
          margin: const EdgeInsets.only( right: 20.0),
 child :   DropdownButton<String>(
    value: dropdownValue,
    icon: Icon(Icons.arrow_drop_down),
    iconEnabledColor: Colors.black,
    iconSize: 24,
    elevation: 16,
    style: TextStyle(color: Colors.black),
    underline: Container(
    height: 2,
    color: Colors.black,
    ),
    onChanged: (String newValue) {
    setState(() {
    dropdownValue = newValue;
    });
    },
    items: <String>['1', '2', '3']

        .map<DropdownMenuItem<String>>((String value) {
    return DropdownMenuItem<String>(
    value: value,
    child: Text(value),
    );
    }).toList(),
    )
      ),

       Text(
          'حدد التكرار !',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
            fontSize: 17.0,
            fontFamily: "Tajawal",
          ),
      ),
    ]) ,

    Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Container(
        margin: const EdgeInsets.only( right: 20.0),
        child:
    OutlineButton(
    onPressed: () => _selectTime(context),
child: Text(
      repeateTime,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.black,
        fontSize: 15.0,
        fontFamily: "Tajawal",
      ),
      )
    ),
    ),


        Text(
          'أي ساعة تفضل ؟',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
            fontSize: 17.0,
            fontFamily: "Tajawal",
          ),

        ),

    ],
    ),
    ]))),


    Column(

    mainAxisAlignment: MainAxisAlignment.end,
    children: <Widget>[
    AdmobBanner(
    adUnitId: getBannerAdUnitId(),
    adSize: AdmobBannerSize.BANNER,
    ),
    ],
    ),
    ]
    )
    )
    ,
    );
  }
  getRepeateTime() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'repeate_notification';
    final value = prefs.getString(key) ?? "";
    if (value == null)
      repeateTime = "اختر الوقت" ;
    else
    repeateTime = value;
  }
  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked_s = await showTimePicker(
        context: context,

        initialTime: selectedTime,
        builder: (BuildContext context, Widget child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
            child: child,
          );
        });
    final prefs = await SharedPreferences.getInstance();
    final key = 'repeate_notification';


    if (picked_s != null && picked_s != selectedTime)
      setState(() {
        selectedTime = picked_s;
        repeateTime = picked_s.hour.toString() + " " + picked_s.minute.toString();
        prefs.setString(key, repeateTime);
        showNotificationDaily(selectedTime.hour, selectedTime.minute);
      });
  }

  _requestIOSPermission() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()
        .requestPermissions(
      alert: false,
      badge: true,
      sound: true,
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


  showNotificationDaily(int hour, int minute) async {
    var time = new Time(hour, minute, 0);
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'repeatDailyAtTime channel id',
        'repeatDailyAtTime channel name',
        'repeatDailyAtTime description');
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.showDailyAtTime(
        0,
        'show daily title',
        'Daily notification shown at approximately',
        time,
        platformChannelSpecifics);
  }
}
