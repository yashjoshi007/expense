import 'package:expense/presentation/screens/expense_summary_screen.dart';
import 'package:expense/presentation/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import '../../data/models/expense_model.dart';
import '../providers/expense_provider.dart';
import 'add_expense_screen.dart';
import '../../core/notifications/notifications_service.dart';
import '../providers/auth_provider.dart';

String formatCustomDate(String dateTimeString) {
  try {
    DateTime dateTime = DateTime.parse(dateTimeString);
    return DateFormat("MMMM dd").format(dateTime); // "February 10"
  } catch (e) {
    return "Invalid Date";
  }
}class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final expenses = Provider.of<ExpenseProvider>(context).expenses;
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Expense Tracker',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 20),
        ),
        backgroundColor: Colors.deepPurple,
        elevation: 5,
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              authProvider.logout();
            },
          ),
          IconButton(
            icon: Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsScreen()),
              );
            },
          ),
        ],
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple, Colors.purpleAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: expenses.isEmpty
          ? Center(
              child: Text(
                "No expenses added yet.",
                style: GoogleFonts.poppins(fontSize: 18, color: Colors.grey[700]),
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              itemCount: expenses.length,
              itemBuilder: (ctx, index) {
                final expense = expenses[index];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.deepPurpleAccent,
                      child: Icon(Icons.money, color: Colors.white),
                    ),
                    title: Text(
                      expense.description,
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 16),
                    ),
                    subtitle: Text(
                      "${expense.amount.toStringAsFixed(2)} • ${expense.category} • ${formatCustomDate(expense.date.toString())}",
                      style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600]),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddExpenseScreen(expense: expense),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            Provider.of<ExpenseProvider>(context, listen: false)
                                .deleteExpense(expense.id);
                          },
                        ),
                      ],
                    ),
                  ),
                
                );
              },
            ),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        backgroundColor: Colors.black,
        children: [
          SpeedDialChild(
            child: Icon(Icons.bar_chart, color: Colors.white),
            backgroundColor: Colors.blueAccent,
            label: "Summary",
            labelStyle: GoogleFonts.poppins(),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ExpenseSummaryScreen()),
              );
            },
          ),
          SpeedDialChild(
            child: Icon(Icons.add, color: Colors.white),
            backgroundColor: Colors.green,
            label: "Add Expense",
            labelStyle: GoogleFonts.poppins(),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddExpenseScreen()),
              );
            },
          ),
          SpeedDialChild(
            child: Icon(Icons.notifications, color: Colors.white),
            backgroundColor: Colors.orange,
            label: "Notify Now",
            labelStyle: GoogleFonts.poppins(),
            onTap: () {
              NotificationService.showInstantNotification();
            },
          ),
          SpeedDialChild(
            child: Icon(Icons.timer, color: Colors.white),
            backgroundColor: Colors.pink,
            label: "Schedule Notify",
            labelStyle: GoogleFonts.poppins(),
            onTap: () {
              NotificationService.scheduleNotification();
            },
          ),
          SpeedDialChild(
            child: Icon(Icons.access_time, color: Colors.white),
            backgroundColor: Colors.teal,
            label: "Daily 10PM",
            labelStyle: GoogleFonts.poppins(),
            onTap: () {
              NotificationService.scheduleDailyNotificationAt10PM();
            },
          ),
        ],
      ),
    );
  }
}
