import 'package:flutter/material.dart';
import 'package:hydra_time/Routes/app_routes.dart';
import 'package:hydra_time/core/constants/app_colors.dart';
import 'package:hydra_time/features/user_profile/presentation/providers/user_profile_provider.dart';
import 'package:hydra_time/features/user_profile/presentation/widgets/climate_card.dart';
import 'package:hydra_time/features/user_profile/presentation/widgets/user_setup_header.dart';
import 'package:hydra_time/shared/animations/fade_in_animation.dart';
import 'package:hydra_time/shared/animations/slide_in_animation.dart';
import 'package:hydra_time/shared/widgets/buttons/primary_button.dart';
import 'package:hydra_time/shared/widgets/buttons/secondary_button.dart';
import 'package:provider/provider.dart';

class ClimateScreen extends StatefulWidget {
  const ClimateScreen({super.key});

  @override
  State<ClimateScreen> createState() => _ClimateScreenState();
}

class _ClimateScreenState extends State<ClimateScreen> {
  String _selectedClimate = '';

  final List<Map<String, dynamic>> climates = [
    {
      'label': 'Cold',
      'description': 'Cold & snowy regions',
      'icon': Icons.ac_unit,
      'emoji': '❄️',
    },
    {
      'label': 'Temperate',
      'description': 'Mild climate',
      'icon': Icons.cloud,
      'emoji': '🌤️',
    },
    {
      'label': 'Tropical',
      'description': 'Warm & humid',
      'icon': Icons.cloud_queue,
      'emoji': '🌴',
    },
    {
      'label': 'Hot',
      'description': 'Very hot & dry',
      'icon': Icons.wb_sunny,
      'emoji': '☀️',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your Climate'), centerTitle: true),
      body: Consumer<UserProfileProvider>(
        builder: (context, provider, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FadeInAnimation(
                  child: UserSetupHeader(
                    stepNumber: 4,
                    totalSteps: 6,
                    title: 'Your Climate',
                    subtitle:
                        'Where do you live?  This affects your hydration needs',
                  ),
                ),
                const SizedBox(height: 32),

                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.1,
                  ),
                  itemCount: climates.length,
                  itemBuilder: (context, index) {
                    return SlideInAnimation(
                      delay: Duration(milliseconds: 100 * (index + 1)),
                      direction: SlideDirection.bottom,
                      child: GestureDetector(
                        onTap: () {
                          setState(
                            () => _selectedClimate = climates[index]['label'],
                          );
                          provider.setClimate(climates[index]['label']);
                        },
                        child: ClimateCard(
                          label: climates[index]['label'],
                          description: climates[index]['description'],
                          icon: climates[index]['icon'],
                          emoji: climates[index]['emoji'],
                          isSelected:
                              _selectedClimate == climates[index]['label'],
                        ),
                      ),
                    );
                  },
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
                        onPressed: _selectedClimate.isNotEmpty
                            ? () async {
                                await provider.calculateWaterGoal();
                                if (mounted) {
                                  Navigator.pushNamed(
                                    context,
                                    AppRoutes.preparingYourPlan,
                                  );
                                }
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
}
