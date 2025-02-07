import 'package:hive/hive.dart';
import '../models/expense_model.dart';

class ExpenseService {
  final Box<Expense> _expenseBox = Hive.box<Expense>('expenseBox');

  void addExpense(Expense expense) {
    _expenseBox.put(expense.id, expense);
  }

  List<Expense> getExpenses() {
    return _expenseBox.values.toList();
  }

  void deleteExpense(String id) {
    _expenseBox.delete(id);
  }

  void updateExpense(Expense expense) {
    _expenseBox.put(expense.id, expense);
  }
}
