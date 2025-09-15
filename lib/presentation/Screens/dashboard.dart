import 'package:flutter/material.dart';

class MyDashBoard extends StatefulWidget {
  const MyDashBoard({super.key});

  @override
  State<MyDashBoard> createState() => _MyDashBoardState();
}

class _MyDashBoardState extends State<MyDashBoard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Column(children: [Text("My DashBoard Screen")]));
  }
}
