import 'package:flutter/material.dart';
import 'package:hydra_time/core/constants/app_colors.dart';
import 'package:hydra_time/core/services/logger_service.dart';
import 'package:wave_progress_indicator/wave_progress_indicator.dart';

class MyHomeScreen extends StatefulWidget {
  const MyHomeScreen({super.key});

  @override
  State<MyHomeScreen> createState() => _MyHomeScreenState();
}

class _MyHomeScreenState extends State<MyHomeScreen> {
  final log = LoggerService();

  final double targetWater = 3000.0;
  double currentWater = 0.0;
  double selectedWater = 100.0;

  String _formattedDate() {
    final now = DateTime.now();
    return "${now.day}/${now.month}/${now.year}";
  }

  void _addWater() {
    try {
      if (currentWater >= targetWater) return;

      setState(() {
        currentWater += selectedWater;
        if (currentWater > targetWater) {
          currentWater = targetWater;
        }

        final remaining = targetWater - currentWater;
        if (remaining < 100) {
          selectedWater = remaining > 0 ? remaining : 0;
        } else if (selectedWater > remaining) {
          selectedWater = remaining;
        }
      });
    } catch (e) {
      log.e("Error in Add Water $e");
    }
  }

  void _reset() {
    try {
      setState(() {
        currentWater = 0.0;
        selectedWater = 100.0;
      });
    } catch (e) {
      log.e("Error while Reset the Progress $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    double progress = 0.0;
    double remaining = 0.0;
    double sliderMin = 100.0;
    double sliderMax = 100.0;
    bool sliderDisabled = false;

    try {
      remaining = targetWater - currentWater;
      progress = targetWater == 0.0
          ? 0.0
          : (currentWater / targetWater).clamp(0.0, 1.0);

      sliderMax = remaining < 100 ? 100 : remaining.clamp(100.0, 1000.0);
      sliderDisabled = remaining < 100;
    } catch (e) {
      log.e(" Error in build calculations: $e");
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Home'), centerTitle: false),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              children: [
                Text(
                  "Daily Target: ${(targetWater / 1000).toStringAsFixed(2)} L",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 30),

                Container(
                  height: 400,
                  width: 220,
                  decoration: BoxDecoration(
                    color: AppColors.grey40,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: EdgeInsetsGeometry.all(10),
                    child: WaveProgressIndicator(
                      value: progress,
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primaryColor,
                          AppColors.primaryColor,
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                      waveHeight: 10.0,
                      speed: 1,
                      borderRadius: BorderRadius.circular(10),
                      child: Center(
                        child: Text(
                          "${(currentWater / 1000).toStringAsFixed(2)} L",
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                if (!sliderDisabled) ...[
                  Text(
                    "Add Water: ${selectedWater.toInt()} ml",
                    style: const TextStyle(fontSize: 16),
                  ),
                  Slider(
                    value: selectedWater.clamp(sliderMin, sliderMax),
                    min: sliderMin,
                    max: sliderMax,
                    activeColor: AppColors.primaryColor,
                    divisions: (sliderMax - sliderMin) >= 100
                        ? ((sliderMax - sliderMin) ~/ 100).toInt()
                        : null,
                    label: "${selectedWater.toInt()} ml",
                    onChanged: sliderDisabled
                        ? null
                        : (value) {
                            try {
                              setState(() {
                                selectedWater = value;
                              });
                            } catch (e) {
                              log.e("Error in Slider onChanged: $e");
                            }
                          },
                  ),

                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.local_drink),
                      label: const Text(
                        'Add Water',
                        style: TextStyle(fontSize: 16),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: AppColors.primaryColor,
                      ),
                      onPressed: selectedWater == 0 ? null : _addWater,
                    ),
                  ),

                  const SizedBox(height: 24),
                ] else ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      vertical: 24,
                      horizontal: 20,
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFB2F7EF), Color(0xFF75E6DA)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.teal.withOpacity(0.3),
                          blurRadius: 20,
                          spreadRadius: 2,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.emoji_events_rounded,
                          size: 60,
                          color: Color(0xFF168aad),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          "Goal Achieved!",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF168aad),
                          ),
                        ),
                        const SizedBox(height: 16),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.calendar_today_rounded,
                              size: 18,
                              color: Colors.black87,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              _formattedDate(),
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(width: 20),
                            const Icon(
                              Icons.local_drink_rounded,
                              size: 18,
                              color: Colors.blueAccent,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              "${(currentWater / 1000).toStringAsFixed(2)} L",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: AppColors.grey100,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        const Text(
                          "🎉 You're fully hydrated today!\nKeep up the great habit 💪",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            height: 1.4,
                            color: Colors.black87,
                          ),
                        ),

                        const SizedBox(height: 24),

                        ElevatedButton.icon(
                          onPressed: _reset,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 4,
                          ),
                          icon: const Icon(Icons.restart_alt),
                          label: const Text(
                            "Reset",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
