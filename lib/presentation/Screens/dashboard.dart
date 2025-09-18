import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hydra_time/presentation/Screens/about_us.dart';
import 'package:hydra_time/presentation/Screens/home_screen.dart';
import 'package:hydra_time/presentation/Screens/Reminder/reminder_screen.dart';
import 'package:hydra_time/presentation/Screens/settings_screen.dart';

class MyDashBoard extends StatefulWidget {
  const MyDashBoard({super.key});

  @override
  State<MyDashBoard> createState() => _MyDashBoardState();
}

class _MyDashBoardState extends State<MyDashBoard> {
  int currentIndex = 0;
  List<Widget> widgetList = [
    MyHomeScreen(),
    MyReminderScreen(),
    MySettingsScreen(),
    AboutUsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(children: widgetList, index: currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (newIndex) {
          setState(() {
            currentIndex = newIndex;
          });
        },
        currentIndex: currentIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.bell),
            label: 'Reminder',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.settings),
            label: 'Settings',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.info),
            label: 'About Us',
          ),
        ],
      ),
    );
  }
}
