import 'package:flutter/material.dart';
import 'package:hydra_time/Routes/app_routes.dart';
import 'package:hydra_time/core/constants/app_colors.dart';
import 'package:hydra_time/core/extensions/context_extension.dart';
import 'package:hydra_time/features/user_profile/presentation/providers/user_profile_provider.dart';
import 'package:hydra_time/features/user_profile/presentation/widgets/user_setup_header.dart';
import 'package:hydra_time/shared/animations/animations.dart';
import 'package:hydra_time/shared/widgets/shared_widgets.dart';
import 'package:provider/provider.dart';

class DailyRoutineScreen extends StatefulWidget {
  const DailyRoutineScreen({super.key});

  @override
  State<DailyRoutineScreen> createState() => _DailyRoutineScreenState();
}

class _DailyRoutineScreenState extends State<DailyRoutineScreen> {
  late TextEditingController _wakeUpTimeController;
  late TextEditingController _bedTimeController;
  late TextEditingController _heightController;
  late TextEditingController _weightController;

  @override
  void initState() {
    super.initState();
    _wakeUpTimeController = TextEditingController();
    _bedTimeController = TextEditingController();
    _heightController = TextEditingController();
    _weightController = TextEditingController();
  }

  @override
  void dispose() {
    _wakeUpTimeController.dispose();
    _bedTimeController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  Future<void> _selectTime(
    BuildContext context,
    TextEditingController controller,
    Function(String) onTimeSelected,
  ) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      final formattedTime = picked.format(context);
      controller.text = formattedTime;
      onTimeSelected(formattedTime);

      setState(() {});

      print('Time selected: $formattedTime');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daily Routine'), centerTitle: true),
      body: Consumer<UserProfileProvider>(
        builder: (context, provider, _) {
          print('=== PROVIDER VALUES ===');
          print('Wake Up Time: "${provider.wakeUpTime}"');
          print('Bed Time: "${provider.bedTime}"');
          print('Height: "${provider.height}"');
          print('Weight: "${provider.weight}"');
          print('Is Valid: ${_isFormValid(provider)}');
          print('======================');

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FadeInAnimation(
                  child: UserSetupHeader(
                    stepNumber: 2,
                    totalSteps: 6,
                    title: 'Your Daily Routine',
                    subtitle: 'Help us understand your daily schedule',
                  ),
                ),
                const SizedBox(height: 32),

                SlideInAnimation(
                  delay: const Duration(milliseconds: 100),
                  direction: SlideDirection.bottom,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Wake Up Time',
                        style: context.textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () => _selectTime(
                          context,
                          _wakeUpTimeController,
                          (value) {
                            provider.setWakeUpTime(value);
                            print('Wake up time set to: $value');
                          },
                        ),
                        child: AbsorbPointer(
                          child: CustomTextField(
                            controller: _wakeUpTimeController,
                            hintText: 'Select wake up time',
                            prefixIcon: Icons.wb_sunny,
                            readOnly: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                SlideInAnimation(
                  delay: const Duration(milliseconds: 200),
                  direction: SlideDirection.bottom,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Bed Time', style: context.textTheme.titleMedium),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () =>
                            _selectTime(context, _bedTimeController, (value) {
                              provider.setBedTime(value);
                              print('Bed time set to: $value');
                            }),
                        child: AbsorbPointer(
                          child: CustomTextField(
                            controller: _bedTimeController,
                            hintText: 'Select bed time',
                            prefixIcon: Icons.nights_stay,
                            readOnly: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                SlideInAnimation(
                  delay: const Duration(milliseconds: 300),
                  direction: SlideDirection.bottom,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Height', style: context.textTheme.titleMedium),
                          Text('cm', style: context.textTheme.bodySmall),
                        ],
                      ),
                      const SizedBox(height: 8),
                      CustomTextField(
                        controller: _heightController,
                        hintText: 'Enter your height',
                        prefixIcon: Icons.height,
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          provider.setHeight(value);
                          print('Height set to: $value');
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                SlideInAnimation(
                  delay: const Duration(milliseconds: 400),
                  direction: SlideDirection.bottom,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Weight', style: context.textTheme.titleMedium),
                          Text('kg', style: context.textTheme.bodySmall),
                        ],
                      ),
                      const SizedBox(height: 8),
                      CustomTextField(
                        controller: _weightController,
                        hintText: 'Enter your weight',
                        prefixIcon: Icons.scale,
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          provider.setWeight(value);
                          print('Weight set to: $value');
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),

                if (provider.errorMessage != null)
                  SlideInAnimation(
                    direction: SlideDirection.top,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.errorColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.errorColor),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: AppColors.errorColor,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              provider.errorMessage!,
                              style: const TextStyle(
                                color: AppColors.errorColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 24),

                Row(
                  children: [
                    Expanded(
                      child: SecondaryButton(
                        text: 'Back',
                        icon: Icons.arrow_back,
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: PrimaryButton(
                        text: 'Next',
                        icon: Icons.arrow_forward,
                        onPressed: _isFormValid(provider)
                            ? () {
                                print('Next button pressed - navigating');
                                Navigator.pushNamed(
                                  context,
                                  AppRoutes.yourActivity,
                                );
                              }
                            : null,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  bool _isFormValid(UserProfileProvider provider) {
    final isValid =
        provider.wakeUpTime.trim().isNotEmpty &&
        provider.bedTime.trim().isNotEmpty &&
        provider.height.trim().isNotEmpty &&
        provider.weight.trim().isNotEmpty;

    print('Form validation: $isValid');
    return isValid;
  }
}
