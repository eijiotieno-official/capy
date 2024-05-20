import 'package:capy/notifiers/colors_notifier.dart'; // Import custom notifier
import 'package:capy/screens/home_screen.dart'; // Import home screen
import 'package:flutter/material.dart'; // Import Flutter material package
import 'package:provider/provider.dart'; // Import provider for state management

// Entry point of the application
void main() {
  runApp(const MainApp()); // Run the MainApp widget
}

// Main application widget
class MainApp extends StatelessWidget {
  // Constructor with named parameter
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Register the ColorsNotifier with ChangeNotifierProvider
        ChangeNotifierProvider(create: (_) => ColorsNotifier()),
      ],
      child: MaterialApp(
        theme: ThemeData(
          useMaterial3: true, // Enable Material 3
          colorSchemeSeed: Colors.pink, // Set primary color scheme seed
        ),
        home: const HomeScreen(), // Set the home screen of the app
      ),
    );
  }
}
