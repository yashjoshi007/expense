import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../data/models/expense_model.dart';
import 'package:intl/intl.dart'; // For date formatting

class ExpenseProvider extends ChangeNotifier {
  final Box<Expense> _expenseBox = Hive.box<Expense>('expenseBox');

  List<Expense> get expenses => _expenseBox.values.toList();

  void addExpense(Expense expense) {
    _expenseBox.put(expense.id, expense);
    notifyListeners();
  }

  void editExpense(Expense expense) {
    _expenseBox.put(expense.id, expense);
    notifyListeners();
  }

  void deleteExpense(String id) {
    _expenseBox.delete(id);
    notifyListeners();
  }

  void loadExpenses() {
    notifyListeners();
  }

  // **Weekly Summary Calculation**
  Map<String, double> getWeeklySummary() {
  final now = DateTime.now();
  final startOfWeek = DateTime(now.year, now.month, now.day - (now.weekday - 1)); // Monday
  final endOfWeek = startOfWeek.add(Duration(days: 6)); // Sunday

  Map<String, double> weeklySummary = {};

  for (var expense in expenses) {
    if ((expense.date.isAfter(startOfWeek) || expense.date.isAtSameMomentAs(startOfWeek)) && 
        expense.date.isBefore(endOfWeek)) {
      weeklySummary[expense.category] = (weeklySummary[expense.category] ?? 0) + expense.amount;
    }
  }

  return weeklySummary;
}


  // **Monthly Summary Calculation**
  Map<String, double> getMonthlySummary() {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final endOfMonth = DateTime(now.year, now.month + 1, 0);

    Map<String, double> monthlySummary = {};

    for (var expense in expenses) {
      if (expense.date.isAfter(startOfMonth) && expense.date.isBefore(endOfMonth)) {
        monthlySummary[expense.category] = (monthlySummary[expense.category] ?? 0) + expense.amount;
      }
    }

    return monthlySummary;
  }
}
