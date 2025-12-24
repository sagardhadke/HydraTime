import 'package:flutter/material.dart';
import 'package:hydra_time/Routes/app_routes.dart';
import 'package:hydra_time/core/constants/app_colors.dart';
import 'package:hydra_time/core/extensions/extensions.dart';
import 'package:hydra_time/features/user_profile/presentation/providers/user_profile_provider.dart';
import 'package:hydra_time/features/user_profile/presentation/widgets/gender_selection_card.dart';
import 'package:hydra_time/features/user_profile/presentation/widgets/user_setup_header.dart';
import 'package:hydra_time/shared/animations/animations.dart';
import 'package:hydra_time/shared/widgets/shared_widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({super.key});

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  late TextEditingController _nameController;
  late TextEditingController _dobController;
  String _selectedGender = '';

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _dobController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(data: Theme.of(context), child: child!);
      },
    );

    if (picked != null) {
      final provider = context.read<UserProfileProvider>();
      final formattedDate = DateFormat('dd MMM yyyy').format(picked);
      _dobController.text = formattedDate;
      provider.setDateOfBirth(formattedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Personal Information'),
        centerTitle: true,
      ),
      body: Consumer<UserProfileProvider>(
        builder: (context, provider, _) {
          return SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FadeInAnimation(
                  child: UserSetupHeader(
                    stepNumber: 1,
                    totalSteps: 6,
                    title: 'Tell us about yourself',
                    subtitle:
                        'Your personal information helps us create a personalized plan',
                  ),
                ),
                const SizedBox(height: 32),

                SlideInAnimation(
                  delay: const Duration(milliseconds: 100),
                  direction: SlideDirection.bottom,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Full Name', style: context.textTheme.titleMedium),
                      const SizedBox(height: 8),
                      CustomTextField(
                        controller: _nameController,
                        hintText: 'Enter your full name',
                        prefixIcon: Icons.person,
                        onChanged: (value) => provider.setFullName(value),
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
                      Text(
                        'Date of Birth',
                        style: context.textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),

                      InkWell(
                        onTap: _selectDate,
                        child: IgnorePointer(
                          child: CustomTextField(
                            controller: _dobController,
                            hintText: 'Select your date of birth',
                            prefixIcon: Icons.calendar_today,
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
                      Text('Gender', style: context.textTheme.titleMedium),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() => _selectedGender = 'Male');
                                provider.setGender('Male');
                              },
                              child: GenderSelectionCard(
                                title: 'Male',
                                icon: Icons.male,
                                isSelected: _selectedGender == 'Male',
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() => _selectedGender = 'Female');
                                provider.setGender('Female');
                              },
                              child: GenderSelectionCard(
                                title: 'Female',
                                icon: Icons.female,
                                isSelected: _selectedGender == 'Female',
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() => _selectedGender = 'Other');
                                provider.setGender('Other');
                              },
                              child: GenderSelectionCard(
                                title: 'Other',
                                icon: Icons.more_horiz,
                                isSelected: _selectedGender == 'Other',
                              ),
                            ),
                          ),
                        ],
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

                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: PrimaryButton(
                    text: 'Next',
                    icon: Icons.arrow_forward,
                    onPressed: _isFormValid(provider)
                        ? () => Navigator.pushNamed(
                            context,
                            AppRoutes.dailyRoutine,
                          )
                        : null,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  bool _isFormValid(UserProfileProvider provider) {
    return provider.fullName.isNotEmpty &&
        provider.dateOfBirth.isNotEmpty &&
        _selectedGender.isNotEmpty;
  }
}
