import 'package:bible/core/managers/color_manager.dart';
import 'package:bible/providers/notification_provider.dart';
import 'package:bible/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Future<void> _pickTime(BuildContext context) async {
    final provider = context.read<NotificationProvider>();
    final picked = await showTimePicker(
      context: context,
      initialTime: provider.time,
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.fromSeed(
            seedColor: ColorManager.primary,
            surface: ColorManager.background1,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      await provider.setTime(picked);
    }
  }

  Future<void> _sendTest(BuildContext context) async {
    await NotificationService.instance.sendTestNotification();
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Test notification sent")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        title: Text("Settings", style: theme.textTheme.headlineMedium),
      ),
      body: Consumer<NotificationProvider>(
        builder: (context, state, __) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Daily Devotional Notifications",
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  "Receive the verse of the day every morning.",
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: ColorManager.grey,
                  ),
                ),
                SizedBox(height: 16),
                Card(
                  child: Column(
                    children: [
                      SwitchListTile(
                        title: Text(
                          "Daily Reminder",
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: ColorManager.black
                          ),
                        ),
                        subtitle: Text(
                          state.enabled ? "On" : "Off",
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: ColorManager.grey,
                          ),
                        ),
                        activeTrackColor: ColorManager.primary,
                        value: state.enabled,
                        onChanged: (value) => state.setEnabled(value),
                      ),
                      Divider(height: 1),
                      ListTile(
                        enabled: state.enabled,
                        title: Text(
                          "Notification Time",
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: ColorManager.black
                          ),
                        ),
                        subtitle: Text(
                          MaterialLocalizations.of(context).formatTimeOfDay(
                            state.time,
                          ),
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: ColorManager.grey,
                          ),
                        ),
                        trailing: Icon(
                          Icons.edit_outlined,
                          color: state.enabled
                              ? ColorManager.primary
                              : ColorManager.grey,
                        ),
                        onTap: state.enabled
                            ? () => _pickTime(context)
                            : null,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                Card(
                  child: ListTile(
                    title: Text(
                      "Send test notification",
                      style: theme.textTheme.titleMedium?.copyWith(
                            color: ColorManager.black
                          ),
                    ),
                    subtitle: Text(
                      "Shows today's verse now",
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: ColorManager.grey,
                      ),
                    ),
                    trailing: Icon(Icons.notifications_active_outlined),
                    onTap: () => _sendTest(context),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
