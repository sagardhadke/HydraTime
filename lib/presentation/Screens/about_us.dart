import 'package:flutter/material.dart';
import 'package:hydra_time/core/constants/app_data.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AboutUsScreen extends StatefulWidget {
  const AboutUsScreen({super.key});

  @override
  State<AboutUsScreen> createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  String appVersion = 'Loading...';

  @override
  void initState() {
    super.initState();
    loadAppVersion();
  }

  Future<void> loadAppVersion() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      setState(() {
        appVersion =
            "Version ${packageInfo.version} (Build ${packageInfo.buildNumber})";
      });
    } catch (e) {
      setState(() {
        appVersion = "Version info not available";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentYear = DateTime.now().year;

    return Scaffold(
      appBar: AppBar(title: const Text("About Us"), scrolledUnderElevation: 0),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        children: [
          Center(
            child: Column(
              children: [
                Image.asset("assets/icons/HydraTimeLogo.png", height: 120),
                const SizedBox(height: 16),
                Text(
                  appVersion,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 40),

          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: AppData.appInfo.length,
            itemBuilder: (BuildContext context, int index) {
              final item = AppData.appInfo[index];
              return ListTile(
                leading: Icon(
                  item['icon'] as IconData,
                  color: item['color'] as Color,
                ),
                title: Text(item['title'] as String),
                subtitle: Text(item['subtitle'] as String),
              );
            },
          ),

          const SizedBox(height: 40),
          Center(
            child: Text(
              "© $currentYear HydraTime. All rights reserved.",
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
              textAlign: TextAlign.center,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            "Made with 🫶🏻 by Sagar Dhadke",
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
