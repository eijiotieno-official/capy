import 'package:capy/screens/home_screen.dart'; // Import the home screen
import 'package:flutter/material.dart'; // Import Flutter material package
import 'package:provider/provider.dart'; // Import provider package for state management

import 'notifiers/color_notifier.dart'; // Import the ColorNotifier

// Entry point of the application
void main() {
  // Run the main application widget
  runApp(const MainApp());
}

// MainApp is a stateless widget that sets up the application
class MainApp extends StatelessWidget {
  // Constructor for MainApp, with a constant key
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      // MultiProvider allows multiple providers to be registered
      providers: [
        // Register the ColorNotifier with ChangeNotifierProvider
        ChangeNotifierProvider(create: (_) => ColorNotifier())
      ],
      // The root widget of the application
      child: MaterialApp(
        // Define the light theme
        theme: ThemeData(
          // Enable Material 3
          useMaterial3: true,
          // Set the primary color scheme
          colorSchemeSeed: Colors.pink,
          // Set the brightness to light mode
          brightness: Brightness.light,
        ),
        // Define the dark theme
        darkTheme: ThemeData(
          // Enable Material 3
          useMaterial3: true,
          // Set the primary color scheme
          colorSchemeSeed: Colors.pink,
          // Set the brightness to dark mode
          brightness: Brightness.dark,
        ),
        // Set the home screen of the application
        home: const HomeScreen(),
      ),
    );
  }
}
