import 'package:capy/models/background_color.dart'; // Import custom model for background colors
import 'package:flutter/material.dart'; // Import Flutter material package

// Notifier class for managing background colors
class ColorsNotifier extends ChangeNotifier {
  // List of predefined background colors
  final List<BackgroundColor> _colors = [
    BackgroundColor(
        begin: const Color.fromARGB(255, 230, 122, 135),
        end: const Color.fromARGB(255, 158, 1, 53)),
    BackgroundColor(
        begin: const Color.fromARGB(255, 240, 220, 139),
        end: const Color.fromRGBO(255, 152, 0, 1)),
    BackgroundColor(
        begin: const Color.fromARGB(255, 223, 165, 136),
        end: const Color.fromRGBO(244, 67, 54, 1)),
    BackgroundColor(
        begin: const Color.fromARGB(255, 134, 207, 225),
        end: const Color.fromRGBO(33, 150, 243, 1)),
    BackgroundColor(
        begin: const Color.fromARGB(255, 156, 233, 159),
        end: const Color.fromRGBO(76, 175, 80, 1)),
    BackgroundColor(
        begin: const Color.fromARGB(255, 208, 157, 139),
        end: const Color.fromRGBO(121, 85, 72, 1)),
    BackgroundColor(
        begin: const Color.fromARGB(255, 207, 150, 224),
        end: const Color.fromRGBO(156, 39, 176, 1)),
  ];

  // Getter for the list of background colors
  List<BackgroundColor> get colors => _colors;

  // Index of the current background color
  int _currentColor = 0;

  // Getter for the current background color index
  int get currentColor => _currentColor;

  // Method to switch to the next background color
  void switchColor() {
    if (_currentColor < (_colors.length - 1)) {
      _currentColor++; // Increment the current color index
    } else {
      _currentColor = 0; // Reset to the first color if at the end
    }
    notifyListeners(); // Notify listeners of the change
  }
}
