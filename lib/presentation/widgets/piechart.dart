import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

Widget buildPieChart(Map<String, double> data) {
    if (data.isEmpty) return Center(child: Text("No data available"));

    return Container(
      height: 200,
      child: PieChart(
        PieChartData(
          sections: data.entries.map((entry) {
            return PieChartSectionData(
              value: entry.value,
              title: "${entry.key} \n${entry.value.toStringAsFixed(2)}",
              color: _getCategoryColor(entry.key),
              radius: 50,
            );
          }).toList(),
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Food': return Colors.blue;
      case 'Transport': return Colors.green;
      case 'Shopping': return Colors.orange;
      case 'Bills': return Colors.red;
      default: return Colors.grey;
    }
  }
