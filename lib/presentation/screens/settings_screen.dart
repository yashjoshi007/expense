import 'package:expense/core/notifications/notifications_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isReminderEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadReminderSetting();
  }


  Future<void> _loadReminderSetting() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isReminderEnabled = prefs.getBool('reminder_enabled') ?? false;
    });

    if (_isReminderEnabled) {
      NotificationService.scheduleDailyNotificationAt10PM();
    }
  }


  Future<void> _toggleReminder(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isReminderEnabled = value;
    });
    await prefs.setBool('reminder_enabled', value);

    if (value) {
      NotificationService.scheduleDailyNotificationAt10PM();
    } else {
      NotificationService.cancelAllNotifications(); 
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: ListTile(
        title: Text("Daily Expense Reminder"),
        trailing: Switch(
          value: _isReminderEnabled,
          onChanged: _toggleReminder,
        ),
      ),
    );
  }
}
