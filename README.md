# Expense Tracker App

## 📌 Overview
Expense Tracker is a Flutter-based mobile application that helps users track their expenses efficiently. It provides local storage using Hive, authentication management, and scheduled notifications for reminders.

---

## 📥 Setup & Installation

### 🔹 Prerequisites
- Flutter SDK installed ([Download Flutter](https://flutter.dev/docs/get-started/install))
- Dart installed
- Android/iOS emulator or a physical device

### 🔹 Steps to Run the App
1. **Clone the Repository**
   ```sh
   git clone https://github.com/your-repo/expense-tracker.git
   cd expense-tracker
   ```
2. **Install Dependencies**
   ```sh
   flutter pub get
   ```
3. **Run Hive Initialization** (Required for local storage)
   ```sh
   flutter packages pub run build_runner build
   ```
4. **Run the App**
   ```sh
   flutter run
   ```
   
---

## 📐 Architectural Choices
The project follows a **Layered Architecture** to ensure modularity and maintainability:

```
lib/
│── core/                  # Core functionalities (Auth, Notifications)
│── data/                  # Models and Database (Hive)
│── presentation/          # UI & State Management (Provider)
│── main.dart              # App Entry Point
```

### **🔹 (1) Presentation Layer** (Status - Complete)
📌 **Technologies Used**: Flutter Widgets + Provider

- Manages **UI components and state**.
- Uses **Provider** for state management.
- Ensures **reactive UI updates** based on data changes.

Example: **Expense Provider**
```dart
class ExpenseProvider extends ChangeNotifier {
  List<Expense> _expenses = [];
  List<Expense> get expenses => _expenses;

  void addExpense(Expense expense) {
    _expenses.add(expense);
    Hive.box<Expense>('expenseBox').add(expense);
    notifyListeners();
  }

  void loadExpenses() {
    _expenses = Hive.box<Expense>('expenseBox').values.toList();
    notifyListeners();
  }
}
```

### **🔹 (2) Data Layer** (Status - Complete)
📌 **Technologies Used**: Hive (for local storage)

- Stores **user expenses locally** for offline access.
- Uses Hive to persist data efficiently.

Example: **Expense Model**
```dart
@HiveType(typeId: 0)
class Expense extends HiveObject {
  @HiveField(0)
  final String title;
  
  @HiveField(1)
  final double amount;
  
  @HiveField(2)
  final DateTime date;

  Expense({required this.title, required this.amount, required this.date});
}
```

### **🔹 (3) Core Layer** (Status - Complete)
📌 **Technologies Used**: Hive + Local Notifications

- **AuthService** → Manages authentication.
- **NotificationService** → Schedules expense reminders.

Example: **Notification Service**
```dart
static Future<void> scheduleNotification() async {
  final now = tz.TZDateTime.now(tz.local);
  final scheduledTime = now.add(Duration(seconds: 5));

  await _notificationsPlugin.zonedSchedule(
    1, 'Reminder', 'Don’t forget to log your expenses!',
    scheduledTime,
    const NotificationDetails(
      android: AndroidNotificationDetails('expense_channel', 'Expense Reminder'),
    ),
    androidAllowWhileIdle: true,
    uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
  );
}
```

---

## ✅ Why This Architecture?
✔️ **Scalability** → New features can be added without affecting other layers.
✔️ **Testability** → Each layer is independent, making **unit and integration testing easier**.
✔️ **Separation of Concerns** → UI, Business Logic, and Data are **strictly separated**.
✔️ **Performance Optimization** → Hive ensures **fast local reads/writes**, reducing Firebase calls.

---

## 🔍 Testing Approach (Status - Pending)
- **Unit Tests**: Testing individual components (e.g., Provider logic, Hive storage, Auth functions).
- **Widget Tests**: UI behavior and interaction testing.
- **Integration Tests**: Ensuring the app works correctly across different layers.

---

## 🚀 Future Improvements
- 🔹 **Cloud Sync** → Use Firebase to sync expenses across devices.
- 🔹 **AI-based Categorization** → Predict and auto-tag expenses using AI models.
- 🔹 **Dark Mode & Themes** → Add UI customization for a better user experience.
- 🔹 **Localization** → To make the app multilingual.
- 🔹 **Animations** → Better User experience.
