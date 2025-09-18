import 'package:flutter/material.dart';
import 'package:hydra_time/core/constants/app_colors.dart';

class MyReminderScreen extends StatefulWidget {
  const MyReminderScreen({super.key});

  @override
  State<MyReminderScreen> createState() => _MyReminderScreenState();
}

class _MyReminderScreenState extends State<MyReminderScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(scrolledUnderElevation: 0, title: const Text("Reminder")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/icons/no_notifications.png", height: 200),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        foregroundColor: Colors.white,
        backgroundColor: AppColors.primaryColor,
        onPressed: () {},
        child: Icon(Icons.add),
      ),
    );
  }
}
