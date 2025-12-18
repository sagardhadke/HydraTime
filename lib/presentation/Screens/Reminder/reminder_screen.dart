import 'package:flutter/material.dart';
import 'package:hydra_time/Routes/app_routes.dart';
import 'package:hydra_time/core/constants/app_colors.dart';
import 'package:hydra_time/core/models/reminderModel.dart';
import 'package:hydra_time/provider/reminders_provider.dart';
import 'package:provider/provider.dart';

class MyReminderScreen extends StatefulWidget {
  const MyReminderScreen({super.key});

  @override
  State<MyReminderScreen> createState() => _MyReminderScreenState();
}

class _MyReminderScreenState extends State<MyReminderScreen> {
  @override
  void initState() {
    super.initState();
    // Load reminders when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RemindersProvider>().loadReminders();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: const Text("Reminders"),
        actions: [
          Consumer<RemindersProvider>(
            builder: (context, provider, _) {
              if (provider.hasReminders) {
                return PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert),
                  onSelected: (value) {
                    if (value == 'delete_all') {
                      _showDeleteAllDialog(context);
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'delete_all',
                      child: Row(
                        children: [
                          Icon(Icons.delete_sweep, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Delete All'),
                        ],
                      ),
                    ),
                  ],
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: Consumer<RemindersProvider>(
        builder: (context, provider, child) {
          // Show loading indicator
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // Show error if any
          if (provider.errorMessage != null) {
            return _buildErrorState(provider.errorMessage!);
          }

          // Show empty state if no reminders
          if (!provider.hasReminders && provider.totalReminders == 0) {
            return _buildEmptyState();
          }

          // Show reminders list with filter
          return Column(
            children: [
              _buildFilterChips(provider),
              if (!provider.hasReminders &&
                  provider.currentFilter != ReminderFilter.all)
                _buildNoFilterResults(provider.currentFilter)
              else
                Expanded(child: _buildRemindersList(provider)),
            ],
          );
        },
      ),
      floatingActionButton: _buildFAB(),
    );
  }

  // Filter chips at the top
  Widget _buildFilterChips(RemindersProvider provider) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          _buildFilterChip(
            label: 'All (${provider.totalReminders})',
            isSelected: provider.currentFilter == ReminderFilter.all,
            onTap: () => provider.setFilter(ReminderFilter.all),
          ),
          const SizedBox(width: 8),
          _buildFilterChip(
            label: 'Intervals (${provider.intervalRemindersCount})',
            isSelected: provider.currentFilter == ReminderFilter.intervals,
            onTap: () => provider.setFilter(ReminderFilter.intervals),
          ),
          const SizedBox(width: 8),
          _buildFilterChip(
            label: 'Specific (${provider.specificRemindersCount})',
            isSelected: provider.currentFilter == ReminderFilter.specificTime,
            onTap: () => provider.setFilter(ReminderFilter.specificTime),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(   
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryColor : AppColors.grey40,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? AppColors.primaryColor : AppColors.grey20,
              width: 1.5,
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? Colors.black : Colors.white,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }

  // Empty state
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("assets/icons/no_notifications.png", height: 200),
          const SizedBox(height: 20),
          const Text(
            "No reminders yet",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            "Tap + to create your first reminder",
            style: TextStyle(fontSize: 14, color: Colors.grey[400]),
          ),
        ],
      ),
    );
  }

  // No filter results
  Widget _buildNoFilterResults(ReminderFilter filter) {
    final filterName = filter == ReminderFilter.intervals
        ? 'interval reminders'
        : 'specific time reminders';

    return Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.filter_list_off, size: 80, color: Colors.grey[600]),
            const SizedBox(height: 16),
            Text(
              "No $filterName",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              "Try selecting a different filter",
              style: TextStyle(fontSize: 14, color: Colors.grey[400]),
            ),
          ],
        ),
      ),
    );
  }

  // Error state
  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 80, color: Colors.red[300]),
          const SizedBox(height: 16),
          const Text(
            "Something went wrong",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              error,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey[400]),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () {
              context.read<RemindersProvider>().loadReminders();
            },
            icon: const Icon(Icons.refresh),
            label: const Text("Retry"),
          ),
        ],
      ),
    );
  }

  // Reminders list
  Widget _buildRemindersList(RemindersProvider provider) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      itemCount: provider.reminders.length,
      itemBuilder: (context, index) {
        final reminder = provider.reminders[index];
        return _buildReminderCard(reminder, provider);
      },
    );
  }

  // Reminder card with improved design
  Widget _buildReminderCard(
      ReminderModel reminder, RemindersProvider provider) {
    return Dismissible(
      key: Key(reminder.id.toString()),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.centerRight,
        child: const Icon(Icons.delete, color: Colors.white, size: 28),
      ),
      onDismissed: (_) => _deleteReminder(reminder, provider),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.grey60, AppColors.grey40],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.grey20, width: 1),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => _showReminderDetails(reminder),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Icon based on type
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      reminder.isIntervalType
                          ? Icons.access_time
                          : Icons.schedule,
                      color: AppColors.primaryColor,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Reminder info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          reminder.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          reminder.description,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[400],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: AppColors.primaryColor.withOpacity(0.3),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    reminder.isIntervalType
                                        ? Icons.repeat
                                        : Icons.alarm,
                                    size: 12,
                                    color: AppColors.primaryColor,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    reminder.interval,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppColors.primaryColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Delete button
                  IconButton(
                    onPressed: () => _confirmDelete(reminder, provider),
                    icon: const Icon(Icons.delete_outline),
                    color: Colors.red[300],
                    iconSize: 22,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Show reminder details in a bottom sheet
  void _showReminderDetails(ReminderModel reminder) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.grey60,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    reminder.isIntervalType ? Icons.access_time : Icons.schedule,
                    color: AppColors.primaryColor,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    reminder.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildDetailRow('Type', reminder.typeLabel),
            _buildDetailRow('Time/Interval', reminder.interval),
            _buildDetailRow('Description', reminder.description),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[400],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Confirm delete dialog
  void _confirmDelete(ReminderModel reminder, RemindersProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.grey60,
        title: const Text('Delete Reminder'),
        content: Text(
          'Are you sure you want to delete "${reminder.title}"?',
          style: TextStyle(color: Colors.grey[300]),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteReminder(reminder, provider);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // Delete reminder
  Future<void> _deleteReminder(
      ReminderModel reminder, RemindersProvider provider) async {
    final success = await provider.deleteReminder(reminder);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success
                ? 'Reminder deleted successfully'
                : 'Failed to delete reminder',
          ),
          backgroundColor: success ? Colors.green : Colors.red,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  // Delete all dialog
  void _showDeleteAllDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.grey60,
        title: const Text('Delete All Reminders'),
        content: const Text(
          'Are you sure you want to delete all reminders? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final provider = context.read<RemindersProvider>();
              final success = await provider.deleteAllReminders();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      success
                          ? 'All reminders deleted'
                          : 'Failed to delete reminders',
                    ),
                    backgroundColor: success ? Colors.green : Colors.red,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            child: const Text('Delete All', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // Floating action button
  Widget _buildFAB() {
    return FloatingActionButton.extended(
      heroTag: "addReminderBtn",
      onPressed: () async {
        final result = await Navigator.pushNamed(context, AppRoutes.setupRemainder);
        if (result == true && mounted) {
          context.read<RemindersProvider>().loadReminders();
        }
      },
      backgroundColor: AppColors.primaryColor,
      foregroundColor: Colors.black,
      icon: const Icon(Icons.add),
      label: const Text('Add Reminder'),
    );
  }
}