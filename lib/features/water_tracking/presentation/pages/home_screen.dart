import 'package:flutter/material.dart';
import 'package:hydra_time/Routes/app_routes.dart';
import 'package:hydra_time/core/constants/app_colors.dart';
import 'package:hydra_time/core/extensions/extensions.dart';
import 'package:hydra_time/features/user_profile/presentation/providers/user_profile_provider.dart';
import 'package:hydra_time/features/water_tracking/presentation/providers/water_tracking_provider.dart';
import 'package:hydra_time/features/water_tracking/presentation/widgets/add_water_button.dart';
import 'package:hydra_time/features/water_tracking/presentation/widgets/goal_achieved_widget.dart';
import 'package:hydra_time/features/water_tracking/presentation/widgets/water_intake_list.dart';
import 'package:hydra_time/features/water_tracking/presentation/widgets/water_progress_card.dart';
import 'package:hydra_time/shared/animations/animations.dart';
import 'package:hydra_time/shared/widgets/shared_widgets.dart';
import 'package:provider/provider.dart';

class MyHomeScreen extends StatefulWidget {
  const MyHomeScreen({super.key});

  @override
  State<MyHomeScreen> createState() => _MyHomeScreenState();
}

class _MyHomeScreenState extends State<MyHomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProfile =
          context.read<UserProfileProvider>().userProfile;
      context
          .read<WaterTrackingProvider>()
          .initializeTodayTracking(userProfile);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        title: const Text('Water Intake'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, AppRoutes.reminder),
            icon: const Icon(Icons.notifications_none),
          ),
          IconButton(
            onPressed:  () => Navigator.pushNamed(context, AppRoutes.settings),
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: Consumer<WaterTrackingProvider>(
        builder: (context, provider, _) {
          // Show loading
          if (provider.isLoading && provider.dailyLog == null) {
            return const Center(child: CircularProgressIndicator());
          }

          // Show error
          if (provider.errorMessage != null && provider.dailyLog == null) {
            return CustomErrorWidget(
              title: 'Failed to Load',
              message: provider.errorMessage,
              onRetry: () => provider.initializeTodayTracking(
                context. read<UserProfileProvider>().userProfile,
              ),
            );
          }

          return SingleChildScrollView(
            child:  Column(
              children: [
                // Goal Achieved Celebration
                if (provider.goalAchieved)
                  FadeInAnimation(
                    child: const GoalAchievedWidget(),
                  ),

                // Water Progress Card
                FadeInAnimation(
                  delay: const Duration(milliseconds: 200),
                  child:  Padding(
                    padding: const EdgeInsets.all(20),
                    child: WaterProgressCard(
                      totalIntake: provider.totalIntake,
                      dailyGoal: provider.dailyGoal,
                      percentage: provider.percentage,
                      remainingMl: provider.remainingMl,
                    ),
                  ),
                ),

                // Quick Add Buttons
                SlideInAnimation(
                  delay: const Duration(milliseconds: 400),
                  direction: SlideDirection.bottom,
                  child:  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Quick Add',
                          style: context.textTheme.titleMedium,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: AddWaterButton(
                                amount: 250,
                                onPressed: () =>
                                    _addWater(provider, 250),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: AddWaterButton(
                                amount: 500,
                                onPressed:  () =>
                                    _addWater(provider, 500),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: AddWaterButton(
                                amount: 750,
                                onPressed:  () =>
                                    _addWater(provider, 750),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Water Intake History
                if (provider.intakes.isNotEmpty)
                  SlideInAnimation(
                    delay: const Duration(milliseconds: 600),
                    direction: SlideDirection.bottom,
                    child: Column(
                      crossAxisAlignment:  CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            'Today\'s Intake',
                            style: context.textTheme. titleMedium,
                          ),
                        ),
                        const SizedBox(height: 12),
                        WaterIntakeList(
                          intakes:  provider.intakes,
                          onRemove: (intakeId) =>
                              _removeWater(provider, intakeId),
                        ),
                      ],
                    ),
                  )
                else
                  SlideInAnimation(
                    delay: const Duration(milliseconds: 600),
                    direction: SlideDirection.bottom,
                    child:  Padding(
                      padding: const EdgeInsets.all(40),
                      child: EmptyState(
                        title: 'No water logged yet',
                        subtitle: 'Start by adding your first glass of water',
                        icon: Icons.opacity,
                      ),
                    ),
                  ),

                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton. extended(
        heroTag: 'addWaterBtn',
        onPressed: () => _showAddWaterDialog(),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.black,
        icon: const Icon(Icons.add),
        label: const Text('Add Water'),
      ),
    );
  }

  Future<void> _addWater(WaterTrackingProvider provider, double amount) async {
    final success = await provider.addWater(amount);
    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:  Text('Added ${amount. toInt()} ml of water'),
            backgroundColor: AppColors.successColor,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
          ),
        );
      } else {
        SnackBarHelper.showError(
          context,
          provider.errorMessage ?? 'Failed to add water',
        );
      }
    }
  }

  Future<void> _removeWater(
      WaterTrackingProvider provider, String intakeId) async {
    final success = await provider.removeWater(intakeId);
    if (mounted) {
      if (success) {
        SnackBarHelper.showSuccess(context, 'Water intake removed');
      } else {
        SnackBarHelper.showError(
          context,
          provider.errorMessage ?? 'Failed to remove water',
        );
      }
    }
  }

  void _showAddWaterDialog() {
    showDialog(
      context: context,
      builder: (context) => const AddWaterDialog(),
    );
  }
}

class AddWaterDialog extends StatefulWidget {
  const AddWaterDialog({super.key});

  @override
  State<AddWaterDialog> createState() => _AddWaterDialogState();
}

class _AddWaterDialogState extends State<AddWaterDialog> {
  late TextEditingController _amountController;
  late TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController();
    _notesController = TextEditingController();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).cardColor,
      title: const Text('Add Water Intake'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomTextField(
            controller: _amountController,
            hintText: 'Amount (ml)',
            prefixIcon: Icons.opacity,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: _notesController,
            hintText: 'Notes (optional)',
            prefixIcon: Icons.note,
            maxLines: 2,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () => _handleAddWater(),
          child: const Text('Add'),
        ),
      ],
    );
  }

  Future<void> _handleAddWater() async {
    if (_amountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter an amount')),
      );
      return;
    }

    final amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid amount')),
      );
      return;
    }

    Navigator.pop(context);

    final provider = context.read<WaterTrackingProvider>();
    final success = await provider.addWater(
      amount,
      notes: _notesController.text. isNotEmpty
          ? _notesController.text
          : null,
    );

    if (mounted) {
      if (success) {
        SnackBarHelper.showSuccess(
          context,
          'Added ${amount.toInt()} ml of water',
        );
      } else {
        SnackBarHelper.showError(
          context,
          provider.errorMessage ??  'Failed to add water',
        );
      }
    }
  }
}