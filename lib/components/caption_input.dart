import 'package:flutter/material.dart';

class CaptionInput extends StatelessWidget {
  final TextEditingController textEditingController;
  final TextAlign textAlign;
  final Function(String?) onChanged;
  const CaptionInput({
    super.key,
    required this.textEditingController,
    required this.textAlign,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0), // Padding inside the container
        child: TextField(
          // TextField for user input
          maxLines: null, // Allows multiple lines of input
          controller: textEditingController, // Assigns the text controller
          textAlign: textAlign, // Text alignment based on current index
          style: TextStyle(
            color: Colors.white, // Text color
            fontSize:
                Theme.of(context).textTheme.titleLarge!.fontSize, // Font size
          ),
          decoration: InputDecoration(
            // Decoration for the TextField
            border: InputBorder.none, // Removes border
            hintText: "What's on your mind?", // Placeholder text
            hintStyle: TextStyle(
              color:
                  Colors.white.withOpacity(0.5), // Hint text color with opacity
              fontSize:
                  Theme.of(context).textTheme.titleLarge!.fontSize, // Font size
            ),
          ),
          // Trigger a rebuild whenever the text changes
          onChanged: onChanged,
        ),
      ),
    );
  }
}
