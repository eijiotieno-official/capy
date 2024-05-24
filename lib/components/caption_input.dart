import 'package:flutter/material.dart';

// Define a StatelessWidget named CaptionInput
class CaptionInput extends StatelessWidget {
  // Define the properties required for the CaptionInput widget
  final TextEditingController textEditingController;
  final TextAlign textAlign;
  final Function(String?) onChanged;

  // Constructor to initialize the properties with required parameters
  const CaptionInput(
      {super.key,
      required this.textEditingController,
      required this.textAlign,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Center(
      // Center the TextField within its parent
      child: Padding(
        padding: const EdgeInsets.all(16.0), // Add padding around the TextField
        child: TextField(
          maxLines: null, // Allows multiple lines of input
          controller:
              textEditingController, // Bind the TextEditingController to the TextField
          textAlign:
              textAlign, // Set the text alignment based on the provided value
          style: TextStyle(
            color: Colors.white, // Set the text color to white
            fontSize: Theme.of(context)
                .textTheme
                .titleLarge!
                .fontSize, // Use the font size from the theme
          ),
          decoration: InputDecoration(
            border: InputBorder.none, // Remove the default border
            hintText:
                "What's on your mind?", // Placeholder text when the field is empty
            hintStyle: TextStyle(
              color: Colors.white.withOpacity(
                  0.5), // Set hint text color with opacity for a faded effect
              fontSize: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .fontSize, // Use the same font size for the hint
            ),
          ),
          onChanged:
              onChanged, // Trigger the onChanged callback whenever the text changes
        ),
      ),
    );
  }
}
