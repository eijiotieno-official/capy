import 'package:flutter/material.dart';

class CaptionInput extends StatelessWidget {
  final TextEditingController textEditingController;
  final TextAlign textAlign;
  final Function(String?) onChanged;
  const CaptionInput(
      {super.key,
      required this.textEditingController,
      required this.textAlign,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          maxLines: null, // Allows multiple lines of input
          controller: textEditingController,
          textAlign: textAlign,
          style: TextStyle(
            color: Colors.white,
            fontSize: Theme.of(context).textTheme.titleLarge!.fontSize,
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "What's on your mind?",
            hintStyle: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: Theme.of(context).textTheme.titleLarge!.fontSize,
            ),
          ),
          onChanged: onChanged, // Trigger a rebuild whenever the text changes
        ),
      ),
    );
  }
}
