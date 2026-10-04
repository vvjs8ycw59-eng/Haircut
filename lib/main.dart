import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:haircut/screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp();
  } catch (_) {
    // Nếu Firebase chưa được cấu hình, app vẫn chạy với dữ liệu mẫu.
  }

  runApp(const HaircutApp());
}

class HaircutApp extends StatelessWidget {
  const HaircutApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Haircut Manager',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF111827)),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
