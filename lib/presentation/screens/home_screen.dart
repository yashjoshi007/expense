import 'package:expense/presentation/screens/expense_summary_screen.dart';
import 'package:expense/presentation/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/expense_model.dart';
import '../providers/expense_provider.dart';
import 'add_expense_screen.dart';
import '../../core/notifications/notifications_service.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final expenses = Provider.of<ExpenseProvider>(context).expenses;

    return Scaffold(
      appBar: AppBar(
        title: Text('Expense Tracker'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: expenses.isEmpty
          ? Center(child: Text("No expenses added yet."))
          : ListView.builder(
              itemCount: expenses.length,
              itemBuilder: (ctx, index) {
                final expense = expenses[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    title: Text(expense.description),
                    subtitle: Text("${expense.amount.toStringAsFixed(2)} • ${expense.category}"),
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
      floatingActionButton: Column(
  mainAxisSize: MainAxisSize.min,
  children: [
    FloatingActionButton(
      heroTag: 'summary',
      child: Icon(Icons.bar_chart),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ExpenseSummaryScreen()),
        );
      },
    ),
    SizedBox(height: 10),
    FloatingActionButton(
      heroTag: 'add',
      child: Icon(Icons.add),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddExpenseScreen()),
        );
      },
    ),
    SizedBox(height: 10),
    FloatingActionButton(
      heroTag: 'notify',
      child: Icon(Icons.notifications),
      onPressed: () {
        NotificationService.showInstantNotification();
      },
    ),
    SizedBox(height: 10),
    FloatingActionButton(
      heroTag: 'schedule',
      child: Icon(Icons.timer),
      onPressed: () {
        NotificationService.scheduleNotification();
      },
    ),
    SizedBox(height: 10),
    FloatingActionButton(
      heroTag: 'daily10pm',
      child: Icon(Icons.access_time),
      onPressed: () {
        NotificationService.scheduleDailyNotificationAt10PM();
      },
    ),
  ],
),

    );
  }
}
