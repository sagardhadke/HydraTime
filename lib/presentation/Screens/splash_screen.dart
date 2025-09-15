import 'package:flutter/material.dart';

class MySplashScreen extends StatefulWidget {
  const MySplashScreen({super.key});

  @override
  State<MySplashScreen> createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              "Poppins Regular",
              style: TextStyle(fontWeight: FontWeight.w400),
            ),
            Text(
              "Poppins Medium",
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            Text(
              "Poppins SemiBold",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            Text("Poppins Bold", style: TextStyle(fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }
}
