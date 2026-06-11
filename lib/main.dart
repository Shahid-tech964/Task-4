import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/home_screen.dart';
import 'services/progress_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const LittleExplorerApp());
}

class LittleExplorerApp extends StatelessWidget {
  const LittleExplorerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProgressProvider(),
      child: MaterialApp(
        title: 'Little Explorer',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF42A5F5),
            brightness: Brightness.light,
          ),
          textTheme: const TextTheme(
            headlineLarge: TextStyle(fontWeight: FontWeight.bold),
            headlineMedium: TextStyle(fontWeight: FontWeight.bold),
            titleLarge: TextStyle(fontWeight: FontWeight.w600),
          ),
          snackBarTheme: SnackBarThemeData(
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
