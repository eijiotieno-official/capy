import 'package:flutter/material.dart';

// A model class representing a background color with a gradient effect
class BackgroundColor {
  // The starting color of the gradient
  final Color begin;
  // The ending color of the gradient
  final Color end;

  // Constructor for the BackgroundColor class
  // The 'required' keyword ensures that both 'begin' and 'end' are mandatory parameters
  BackgroundColor({
    required this.begin,
    required this.end,
  });
}
