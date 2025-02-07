import 'package:flutter/material.dart';
import '../../data/local/expense_service.dart';
import '../../data/models/expense_model.dart';

class ExpenseProvider with ChangeNotifier {
  final ExpenseService _service = ExpenseService();
  List<Expense> _expenses = [];

  List<Expense> get expenses => _expenses;

  void loadExpenses() {
    _expenses = _service.getExpenses();
    notifyListeners();
  }

  void addExpense(Expense expense) {
    _service.addExpense(expense);
    loadExpenses();
  }

  void deleteExpense(String id) {
    _service.deleteExpense(id);
    loadExpenses();
  }
}
