# hydra_time

📁 Complete Clean Architecture Project Structure

hydra_time/
├── lib/
│   ├── core/
│   │   ├── constants/
│   │   │   ├── app_colors.dart
│   │   │   ├── app_strings.dart
│   │   │   ├── app_dimensions.dart
│   │   │   └── app_assets.dart
│   │   │
│   │   ├── theme/
│   │   │   ├── app_theme.dart
│   │   │   ├── light_theme.dart
│   │   │   ├── dark_theme.dart
│   │   │   └── theme_provider.dart
│   │   │
│   │   ├── errors/
│   │   │   ├── failures.dart
│   │   │   └── exceptions.dart
│   │   │
│   │   ├── utils/
│   │   │   ├── validators.dart
│   │   │   ├── date_formatter.dart
│   │   │   ├── water_calculator.dart
│   │   │   └── notification_helper.dart
│   │   │
│   │   ├── extensions/
│   │   │   ├── context_extension.dart
│   │   │   ├── string_extension.dart
│   │   │   ├── datetime_extension.dart
│   │   │   └── number_extension.dart
│   │   │
│   │   ├── usecases/
│   │   │   └── usecase.dart
│   │   │
│   │   └── network/
│   │       └── network_info.dart (for future API)
│   │
│   ├── config/
│   │   ├── routes/
│   │   │   ├── app_router.dart
│   │   │   └── route_names.dart
│   │   │
│   │   ├── dependency_injection/
│   │   │   └── injection_container.dart
│   │   │
│   │   └── app_config.dart
│   │
│   ├── shared/
│   │   ├── widgets/
│   │   │   ├── buttons/
│   │   │   │   ├── primary_button.dart
│   │   │   │   ├── secondary_button.dart
│   │   │   │   └── icon_button_widget.dart
│   │   │   │
│   │   │   ├── inputs/
│   │   │   │   ├── custom_text_field.dart
│   │   │   │   ├── custom_dropdown.dart
│   │   │   │   └── time_picker_field.dart
│   │   │   │
│   │   │   ├── cards/
│   │   │   │   ├── info_card.dart
│   │   │   │   ├── stats_card.dart
│   │   │   │   └── selection_card.dart
│   │   │   │
│   │   │   ├── dialogs/
│   │   │   │   ├── confirmation_dialog.dart
│   │   │   │   ├── loading_dialog.dart
│   │   │   │   └── custom_bottom_sheet.dart
│   │   │   │
│   │   │   ├── feedback/
│   │   │   │   ├── loading_indicator.dart
│   │   │   │   ├── empty_state.dart
│   │   │   │   ├── error_widget.dart
│   │   │   │   └── snackbar_helper.dart
│   │   │   │
│   │   │   └── layouts/
│   │   │       ├── responsive_builder.dart
│   │   │       └── custom_app_bar.dart
│   │   │
│   │   └── animations/
│   │       ├── fade_in_animation.dart
│   │       ├── slide_in_animation.dart
│   │       └── scale_animation.dart
│   │
│   ├── features/
│   │   │
│   │   ├── onboarding/
│   │   │   ├── data/
│   │   │   │   ├── models/
│   │   │   │   │   └── onboarding_model.dart
│   │   │   │   ├── datasources/
│   │   │   │   │   └── onboarding_local_datasource.dart
│   │   │   │   └── repositories/
│   │   │   │       └── onboarding_repository_impl.dart
│   │   │   │
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   └── onboarding.dart
│   │   │   │   ├── repositories/
│   │   │   │   │   └── onboarding_repository.dart
│   │   │   │   └── usecases/
│   │   │   │       ├── complete_onboarding.dart
│   │   │   │       └── check_onboarding_status.dart
│   │   │   │
│   │   │   └── presentation/
│   │   │       ├── providers/
│   │   │       │   └── onboarding_provider.dart
│   │   │       ├── pages/
│   │   │       │   └── onboarding_screen.dart
│   │   │       └── widgets/
│   │   │           ├── onboarding_page_widget.dart
│   │   │           └── page_indicator.dart
│   │   │
│   │   ├── user_profile/
│   │   │   ├── data/
│   │   │   │   ├── models/
│   │   │   │   │   └── user_profile_model.dart
│   │   │   │   ├── datasources/
│   │   │   │   │   └── user_profile_local_datasource.dart
│   │   │   │   └── repositories/
│   │   │   │       └── user_profile_repository_impl.dart
│   │   │   │
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   └── user_profile.dart
│   │   │   │   ├── repositories/
│   │   │   │   │   └── user_profile_repository.dart
│   │   │   │   └── usecases/
│   │   │   │       ├── save_user_profile.dart
│   │   │   │       ├── get_user_profile.dart
│   │   │   │       └── calculate_water_goal.dart
│   │   │   │
│   │   │   └── presentation/
│   │   │       ├── providers/
│   │   │       │   └── user_profile_provider.dart
│   │   │       ├── pages/
│   │   │       │   ├── personal_info_screen.dart
│   │   │       │   ├── daily_routine_screen.dart
│   │   │       │   ├── activity_screen.dart
│   │   │       │   ├── climate_screen.dart
│   │   │       │   ├── preparing_plan_screen.dart
│   │   │       │   └── water_suggestion_screen.dart
│   │   │       └── widgets/
│   │   │           ├── gender_selection_card.dart
│   │   │           ├── activity_card.dart
│   │   │           └── climate_card.dart
│   │   │
│   │   ├── water_tracking/
│   │   │   ├── data/
│   │   │   │   ├── models/
│   │   │   │   │   ├── water_intake_model.dart
│   │   │   │   │   └── daily_log_model.dart
│   │   │   │   ├── datasources/
│   │   │   │   │   └── water_tracking_local_datasource.dart
│   │   │   │   └── repositories/
│   │   │   │       └── water_tracking_repository_impl.dart
│   │   │   │
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   ├── water_intake.dart
│   │   │   │   │   └── daily_log.dart
│   │   │   │   ├── repositories/
│   │   │   │   │   └── water_tracking_repository.dart
│   │   │   │   └── usecases/
│   │   │   │       ├── add_water_intake.dart
│   │   │   │       ├── get_daily_intake.dart
│   │   │   │       ├── reset_daily_intake.dart
│   │   │   │       └── get_intake_history.dart
│   │   │   │
│   │   │   └── presentation/
│   │   │       ├── providers/
│   │   │       │   └── water_tracking_provider.dart
│   │   │       ├── pages/
│   │   │       │   └── home_screen.dart
│   │   │       └── widgets/
│   │   │           ├── water_wave_widget.dart
│   │   │           ├── water_slider_widget.dart
│   │   │           ├── add_water_button.dart
│   │   │           └── goal_achieved_widget.dart
│   │   │
│   │   ├── reminders/
│   │   │   ├── data/
│   │   │   │   ├── models/
│   │   │   │   │   └── reminder_model.dart
│   │   │   │   ├── datasources/
│   │   │   │   │   └── reminder_local_datasource.dart
│   │   │   │   └── repositories/
│   │   │   │       └── reminder_repository_impl.dart
│   │   │   │
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   └── reminder.dart
│   │   │   │   ├── repositories/
│   │   │   │   │   └── reminder_repository.dart
│   │   │   │   └── usecases/
│   │   │   │       ├── add_reminder.dart
│   │   │   │       ├── get_all_reminders.dart
│   │   │   │       ├── delete_reminder.dart
│   │   │   │       ├── update_reminder.dart
│   │   │   │       └── filter_reminders.dart
│   │   │   │
│   │   │   └── presentation/
│   │   │       ├── providers/
│   │   │       │   └── reminders_provider.dart
│   │   │       ├── pages/
│   │   │       │   ├── reminder_list_screen.dart
│   │   │       │   ├── setup_reminder_screen.dart
│   │   │       │   ├── interval_reminder_screen.dart
│   │   │       │   └── specific_reminder_screen.dart
│   │   │       └── widgets/
│   │   │           ├── reminder_card.dart
│   │   │           ├── filter_chip_widget.dart
│   │   │           └── reminder_type_card.dart
│   │   │
│   │   ├── statistics/
│   │   │   ├── data/
│   │   │   │   ├── models/
│   │   │   │   │   ├── statistics_model.dart
│   │   │   │   │   └── achievement_model.dart
│   │   │   │   ├── datasources/
│   │   │   │   │   └── statistics_local_datasource.dart
│   │   │   │   └── repositories/
│   │   │   │       └── statistics_repository_impl.dart
│   │   │   │
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   ├── statistics.dart
│   │   │   │   │   └── achievement.dart
│   │   │   │   ├── repositories/
│   │   │   │   │   └── statistics_repository.dart
│   │   │   │   └── usecases/
│   │   │   │       ├── get_daily_stats.dart
│   │   │   │       ├── get_weekly_stats.dart
│   │   │   │       ├── get_monthly_stats.dart
│   │   │   │       ├── get_streak.dart
│   │   │   │       └── get_achievements.dart
│   │   │   │
│   │   │   └── presentation/
│   │   │       ├── providers/
│   │   │       │   └── statistics_provider.dart
│   │   │       ├── pages/
│   │   │       │   └── statistics_screen.dart
│   │   │       └── widgets/
│   │   │           ├── stats_chart_widget.dart
│   │   │           ├── streak_widget.dart
│   │   │           ├── achievement_card.dart
│   │   │           └── period_selector.dart
│   │   │
│   │   ├── settings/
│   │   │   ├── data/
│   │   │   │   ├── models/
│   │   │   │   │   └── settings_model.dart
│   │   │   │   ├── datasources/
│   │   │   │   │   └── settings_local_datasource.dart
│   │   │   │   └── repositories/
│   │   │   │       └── settings_repository_impl.dart
│   │   │   │
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   └── app_settings.dart
│   │   │   │   ├── repositories/
│   │   │   │   │   └── settings_repository.dart
│   │   │   │   └── usecases/
│   │   │   │       ├── get_settings.dart
│   │   │   │       ├── update_theme.dart
│   │   │   │       ├── export_data.dart
│   │   │   │       └── clear_all_data.dart
│   │   │   │
│   │   │   └── presentation/
│   │   │       ├── providers/
│   │   │       │   └── settings_provider.dart
│   │   │       ├── pages/
│   │   │       │   └── settings_screen.dart
│   │   │       └── widgets/
│   │   │           ├── settings_tile.dart
│   │   │           └── theme_switcher.dart
│   │   │
│   │   ├── about/
│   │   │   └── presentation/
│   │   │       ├── providers/
│   │   │       │   └── about_provider.dart
│   │   │       ├── pages/
│   │   │       │   └── about_screen.dart
│   │   │       └── widgets/
│   │   │           └── info_tile.dart
│   │   │
│   │   ├── dashboard/
│   │   │   └── presentation/
│   │   │       ├── pages/
│   │   │       │   └── dashboard_screen.dart
│   │   │       └── widgets/
│   │   │           └── bottom_nav_bar.dart
│   │   │
│   │   └── splash/
│   │       └── presentation/
│   │           └── pages/
│   │               └── splash_screen.dart
│   │
│   ├── services/
│   │   ├── notification/
│   │   │   ├── notification_service.dart
│   │   │   └── notification_handler.dart
│   │   │
│   │   ├── storage/
│   │   │   ├── hive_service.dart
│   │   │   └── migration_service.dart
│   │   │
│   │   └── platform/
│   │       ├── permission_service.dart
│   │       └── platform_service.dart
│   │
│   └── main.dart
│
├── assets/
│   ├── fonts/
│   ├── icons/
│   └── images/
│
├── test/
│   ├── features/
│   ├── shared/
│   └── core/
│
├── integration_test/
│
├── android/
├── ios/
├── pubspec.yaml
├── analysis_options.yaml
└── README.md
