import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../data/models/expense_model.dart';

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
}
