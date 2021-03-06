
import 'package:admob_flutter/admob_flutter.dart';

import 'package:flutter/material.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:io';
import 'BottomNavigationBarController.dart';





void main() {
  Crashlytics.instance.enableInDevMode = true;
  FlutterError.onError = Crashlytics.instance.recordFlutterError;


  runZoned(()  {
    WidgetsFlutterBinding.ensureInitialized();

    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp,DeviceOrientation.portraitDown]);

    Admob.initialize(getAppId() );
    runApp(MaterialApp(
      theme: ThemeData(
        primarySwatch: primary,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: BottomNavigationBarController(),
    ));

    }, onError: Crashlytics.instance.recordError);




}
String getAppId() {
  if (Platform.isIOS) {
    return 'ca-app-pub-6139571964236523~6106296741';
  } else if (Platform.isAndroid) {
    return 'ca-app-pub-6139571964236523~9864854604';
  }
  return null;
}
 const MaterialColor primary = MaterialColor(
  0xFFa4ced4,
  <int, Color>{
    50: Color(0xFFa4ced4),
    100: Color(0xFFa4ced4),
    200: Color(0xFFa4ced4),
    300: Color(0xFFa4ced4),
    400: Color(0xFFa4ced4),
    500: Color(0xFFa4ced4),
    600: Color(0xFFa4ced4),
    700: Color(0xFFa4ced4),
    800: Color(0xFFa4ced4),
    900: Color(0xFFa4ced4),
  },
);