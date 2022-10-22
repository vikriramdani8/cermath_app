import 'dart:async';
import 'package:cermath_app/common/style/style_common.dart';
import 'package:cermath_app/common/style/style_text.dart';
import 'package:cermath_app/common/widget/widget_alert.dart';
import 'package:cermath_app/features/homepage/dashboard/homepage_dashboard.dart';
import 'package:cermath_app/features/homepage/leaderboard/homepage_leaderboard.dart';
import 'package:cermath_app/features/homepage/profile/homepage_profile.dart';
import 'package:flutter/material.dart';
import 'package:cermath_app/common/style/style_color.dart';
import 'package:cermath_app/common/widget/widget_shared.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int _currentIndex = 0;

  StyleText styleText = new StyleText();
  StyleColor styleColor = new StyleColor();
  StyleCommon styleCommon = new StyleCommon();
  WidgetShared widgetShared = new WidgetShared();
  WidgetAlert widgetAlert = new WidgetAlert();

  Widget homeWidget = Container();

  Future<bool> _onWillPop() async {
    return (await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Apakah kamu yakin?'),
        content: Text('Ingin menutup aplikasi'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Tidak'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Ya'),
          ),
        ],
      ),
    )) ?? false;
  }

  @override
  Widget build(BuildContext context) {

    switch(_currentIndex) {
      case 0:
        homeWidget = HomepageDashboard();
        break;
      case 1:
        homeWidget = HomepageLeaderboard();
        break;
      case 2:
        homeWidget = HomepageProfile();
        break;
    }

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: homeWidget,
        bottomNavigationBar: BottomNavigationBar(
          showSelectedLabels: false,
          showUnselectedLabels: false,
          onTap: (index) => setState(() {
            _currentIndex = index;
          }),
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.album, color: _currentIndex == 0 ? styleColor.colorRed : Colors.black54, size: 30),
                label: '1'
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.leaderboard, color: _currentIndex == 1 ? styleColor.colorRed : Colors.black54, size: 30),
                label: '2'
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.account_circle_rounded, color: _currentIndex == 2 ? styleColor.colorRed : Colors.black54, size: 30),
                label: '3'
            )
          ],
        ),
      ),
    );
  }
}
