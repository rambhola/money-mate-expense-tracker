import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'models/transaction.dart';
import 'models/goal.dart';
import 'controllers/transaction_controller.dart';
import 'controllers/goal_controller.dart';
import 'controllers/profile_controller.dart';
import 'views/main_navigation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  
  Hive.registerAdapter(TransactionAdapter());
  Hive.registerAdapter(GoalAdapter());
  
  await Hive.openBox<Transaction>('transactions');
  await Hive.openBox<Goal>('goals');
  
  Get.put(TransactionController());
  Get.put(GoalController());
  Get.put(ProfileController());
  
  runApp(const MoneyMateApp());
}

class MoneyMateApp extends StatelessWidget {
  const MoneyMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'MoneyMate',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6C63FF),
          primary: const Color(0xFF6C63FF),
          secondary: const Color(0xFF00B894),
          surface: Colors.white,
        ),
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      home: const MainNavigation(),
    );
  }
}
