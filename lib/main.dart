import 'package:expense/core/auth/auth_service.dart';
import 'package:expense/presentation/providers/auth_provider.dart';
import 'package:expense/presentation/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'data/models/expense_model.dart';
import 'presentation/providers/expense_provider.dart';
import 'presentation/screens/home_screen.dart';
import 'core/notifications/notifications_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await AuthService.initHive();
  Hive.registerAdapter(ExpenseAdapter());
  await Hive.openBox<Expense>('expenseBox');

  tz.initializeTimeZones();
  await NotificationService.initialize();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ExpenseProvider()..loadExpenses()),
        ChangeNotifierProvider(create: (_) => AuthProvider()), // Added AuthProvider
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Expense Tracker',
          theme: ThemeData(primarySwatch: Colors.blue),
          home: authProvider.isLoggedIn ? HomeScreen() : LoginScreen(),
        );
      },
    );
  }
}
