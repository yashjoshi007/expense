import 'package:hive/hive.dart';

part 'expense_model.g.dart'; // This will be generated

@HiveType(typeId: 0)
class Expense extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  double amount;

  @HiveField(2)
  DateTime date;

  @HiveField(3)
  String description;

  @HiveField(4)
  String category;

  Expense({
    required this.id,
    required this.amount,
    required this.date,
    required this.description,
    required this.category,
  });
}
