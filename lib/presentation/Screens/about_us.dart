import 'package:flutter/material.dart';
import 'package:hydra_time/core/constants/app_data.dart';
import 'package:hydra_time/provider/about_us_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUsScreen extends StatefulWidget {
  const AboutUsScreen({super.key});

  @override
  State<AboutUsScreen> createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  @override
  void initState() {
    super.initState();
    loadAppVersion();
  }

  void loadAppVersion() {
    Provider.of<AboutUsProvider>(context, listen: false).loadAppVersion();
  }

  @override
  Widget build(BuildContext context) {
    final currentYear = DateTime.now().year;

    return Scaffold(
      appBar: AppBar(title: const Text("About Us"), scrolledUnderElevation: 0),
      body: Consumer<AboutUsProvider>(
        builder: (context, provider, child) {
          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            children: [
              Center(
                child: Column(
                  children: [
                    Image.asset("assets/icons/HydraTimeLogo.png", height: 120),
                    const SizedBox(height: 16),
                    Text(
                      provider.appVersion,
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
                    onTap: () async {
                      try {
                        if (item['subtitle'].toString().startsWith("https")) {
                          await launchUrl(Uri.parse(item['subtitle']));
                        }
                        if (item['subtitle'].toString().contains("@")) {
                          await launchUrl(
                            Uri.parse("mailto:${item['subtitle']}"),
                          );
                        }
                      } catch (e) {
                        debugPrint("Error ${e.toString()}");
                      }
                    },
                  );
                },
              ),

              const SizedBox(height: 40),
              Center(
                child: Text(
                  "© $currentYear HydraTime. All rights reserved.",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                "Made with ❤️ by Sagar Dhadke",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 40),
            ],
          );
        },
      ),
    );
  }
}
