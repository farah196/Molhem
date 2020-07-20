import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:custom_splash/custom_splash.dart';

import 'dart:io';
import 'BottomNavigationBarController.dart';
void main() {

  WidgetsFlutterBinding.ensureInitialized();
  Admob.initialize(getAppId() );
  runApp(MaterialApp(
    theme: ThemeData(
      primarySwatch: primary,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    ),
    debugShowCheckedModeBanner: false,
    home: CustomSplash(
      imagePath: 'assets/logo.png',
      backGroundColor: Colors.grey[100],
      animationEffect: 'zoom-in',
      home: BottomNavigationBarController(),
      // customFunction: duringSplash,
      duration: 1500,
      type: CustomSplashType.StaticDuration,
      // outputAndHome: op,
    ),

//      routes: <String, WidgetBuilder>{
//      '/HomePage': (BuildContext context) => new HomePage()
//    },
  ),


  );

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
  0xFFE6C4BB,
  <int, Color>{
    50: Color(0xFFE6C4BB),
    100: Color(0xFFE6C4BB),
    200: Color(0xFFE6C4BB),
    300: Color(0xFFE6C4BB),
    400: Color(0xFFE6C4BB),
    500: Color(0xFFE6C4BB),
    600: Color(0xFFE6C4BB),
    700: Color(0xFFE6C4BB),
    800: Color(0xFFE6C4BB),
    900: Color(0xFFE6C4BB),
  },
);