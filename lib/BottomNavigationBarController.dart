import 'package:flutter/material.dart';
import 'Home.dart';
import 'Reminder.dart';
import 'Favourite.dart';
class BottomNavigationBarController extends StatefulWidget {
  @override
  _BottomNavigationBarControllerState createState() =>
      _BottomNavigationBarControllerState();
}

class _BottomNavigationBarControllerState
    extends State<BottomNavigationBarController> {
  int _selectedIndex = 2;
  final List<Widget> pages = [

    Favourite(
      key: PageStorageKey('Page3'),
    ),
    Reminder(
      key: PageStorageKey('Page2'),
    ),
    Home(
      key: PageStorageKey('Page1'),
    ),
  ];

  final PageStorageBucket bucket = PageStorageBucket();



  Widget _bottomNavigationBar(int selectedIndex) => BottomNavigationBar(
    type: BottomNavigationBarType.fixed,
            selectedItemColor: Color(0xFFf2fbfc),
            backgroundColor: Color(0xFFa4ced4),
    onTap: (int index) => setState(() => _selectedIndex = index),
    currentIndex: selectedIndex,
    items: const <BottomNavigationBarItem>[



      BottomNavigationBarItem(
          title: Text("المفضلة"), icon: Icon(Icons.favorite_border)),
      BottomNavigationBarItem(
          title: Text("التذكيرات"), icon: Icon(Icons.timer)),
      BottomNavigationBarItem(
          title: Text("الرئيسية"), icon: Icon(Icons.home)),

//      BottomNavigationBarItem(
//          title: Text("نمط"), icon: Icon(Icons.brush)),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _bottomNavigationBar(_selectedIndex),
      body: PageStorage(
        child: pages[_selectedIndex],
        bucket: bucket,
      ),
    );
  }
}