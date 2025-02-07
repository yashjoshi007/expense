import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/expense_provider.dart';
import '../widgets/piechart.dart';
class ExpenseSummaryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final expenseProvider = Provider.of<ExpenseProvider>(context);
    final weeklySummary = expenseProvider.getWeeklySummary();
    final monthlySummary = expenseProvider.getMonthlySummary();

    return Scaffold(
      appBar: AppBar(title: Text('Expense Summary')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Weekly Summary', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            buildPieChart(weeklySummary),
            SizedBox(height: 20),
            Text('Monthly Summary', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            buildPieChart(monthlySummary),
          ],
        ),
      ),
    );
  }

  
}

