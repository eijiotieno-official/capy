import 'package:capy/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'notifiers/color_notifier.dart';

// Entry point of the application
void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Register the ColorsNotifier with ChangeNotifierProvider
        ChangeNotifierProvider(create: (_) => ColorNotifier())
      ],
      child: MaterialApp(
        theme: ThemeData(
          // Enable material 3
          useMaterial3: true,
          // Set primary color scheme
          colorSchemeSeed: Colors.pink,
          brightness: Brightness.light,
        ),
        darkTheme: ThemeData(
          // Enable material 3
          useMaterial3: true,
          // Set primary color scheme
          colorSchemeSeed: Colors.pink,
          brightness: Brightness.dark,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
