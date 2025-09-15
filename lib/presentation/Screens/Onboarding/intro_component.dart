import 'package:flutter/material.dart';

class IntroComponent extends StatelessWidget {
  final String title;
  final String description;
  final String imgPath;
  const IntroComponent({
    super.key,
    required this.title,
    required this.description,
    required this.imgPath,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(imgPath, height: 350),
            SizedBox(height: 30),
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsetsGeometry.symmetric(horizontal: 20),
              child: Text(description, textAlign: TextAlign.center),
            ),
          ],
        ),
      ),
    );
  }
}
