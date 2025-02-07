import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/expense_provider.dart';
import 'add_expense_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final expenses = Provider.of<ExpenseProvider>(context).expenses;

    return Scaffold(
      appBar: AppBar(title: Text('Expense Tracker')),
      body: expenses.isEmpty
          ? Center(child: Text("No expenses added yet."))
          : ListView.builder(
              itemCount: expenses.length,
              itemBuilder: (ctx, index) {
                final expense = expenses[index];
                return ListTile(
                  title: Text(expense.description),
                  subtitle: Text("${expense.amount.toStringAsFixed(2)} • ${expense.category}"),
                  trailing: Text("${expense.date.toLocal()}".split(' ')[0]),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddExpenseScreen()),
          );
        },
      ),
    );
  }
}
