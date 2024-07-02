import 'package:firebase_auth/firebase_auth.dart';
import 'package:kharcha/FirstPage.dart';
import 'package:kharcha/NewExpense.dart';
import 'package:kharcha/Profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:kharcha/FirstPage.dart';
import 'package:flutter/material.dart';
import 'listView.dart';

class MainNavigator extends StatefulWidget{
  @override
  _MainNavigationState createState() => _MainNavigationState() ;

}

class _MainNavigationState extends State<MainNavigator> {
  int _selectedIndex = 0;

  final List<Widget> _screens =[
    SecondPage(),
    NewExpense(),
    Profile(),
  ];

  final List<String> _list =[
    'Home',
    'New Transaction',
    'Profile'
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(_list[_selectedIndex],style: TextStyle(color: Colors.white),textScaleFactor: 1.2),
          centerTitle: true,
          backgroundColor: Colors.black,
        ),
        body: _screens[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          backgroundColor: Colors.black,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white54,
          selectedFontSize: 14,
          unselectedFontSize: 10,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon:Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon:Icon(Icons.add_chart_rounded),
              label: 'New Transaction',

            ),
            BottomNavigationBarItem(
              icon:Icon(Icons.account_circle_rounded),
              label: 'Account',
            ),
          ],
          onTap: (index) {
            setState((){
              _selectedIndex = index;
            });
          },
        ),
      ),
    );

  }
}