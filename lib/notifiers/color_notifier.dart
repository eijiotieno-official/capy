import 'package:capy/models/background_color.dart';
import 'package:flutter/material.dart';

// Notifier class for managing background colors
class ColorNotifier extends ChangeNotifier {
  // List of predefined background colors
  final List<BackgroundColor> _colors = [
    BackgroundColor(
        begin: const Color.fromARGB(255, 230, 122, 135), // Starting color
        end: const Color.fromARGB(255, 158, 1, 53)), // Ending color
    BackgroundColor(
        begin: const Color.fromARGB(255, 240, 220, 139), // Starting color
        end: const Color.fromRGBO(255, 152, 0, 1)), // Ending color
    BackgroundColor(
        begin: const Color.fromARGB(255, 223, 165, 136), // Starting color
        end: const Color.fromRGBO(244, 67, 54, 1)), // Ending color
    BackgroundColor(
        begin: const Color.fromARGB(255, 134, 207, 225), // Starting color
        end: const Color.fromRGBO(33, 150, 243, 1)), // Ending color
    BackgroundColor(
        begin: const Color.fromARGB(255, 156, 233, 159), // Starting color
        end: const Color.fromRGBO(76, 175, 80, 1)), // Ending color
    BackgroundColor(
        begin: const Color.fromARGB(255, 208, 157, 139), // Starting color
        end: const Color.fromRGBO(121, 85, 72, 1)), // Ending color
    BackgroundColor(
        begin: const Color.fromARGB(255, 207, 150, 224), // Starting color
        end: const Color.fromRGBO(156, 39, 176, 1)), // Ending color
  ];

  // Getter for the list of background colors
  List<BackgroundColor> get colors => _colors;

  // Index of the current background color
  int _currentColor = 0;

  // Getter for the current background color index
  int get currenColor => _currentColor;

  // Method to switch to the next background color
  void switchColor() {
    // If not at the last color, move to the next color
    if (_currentColor < (_colors.length - 1)) {
      _currentColor++;
    } else {
      // Reset to the first color if at the end
      _currentColor = 0;
    }
    // Notify listeners of the change
    notifyListeners();
  }
}
