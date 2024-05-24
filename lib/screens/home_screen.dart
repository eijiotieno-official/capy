import 'package:capy/components/caption_input.dart';
import 'package:capy/notifiers/color_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Controller for capturing screenshots
  final ScreenshotController _screenshotController = ScreenshotController();

  // Declaring a TextEditingController as final since it won't be reassigned
  final TextEditingController _textEditingController = TextEditingController();

  // Index to track text alignment
  int _textAlign = 0;

  // List of available text alignments
  final List<TextAlign> _textAlignments = [
    TextAlign.center,
    TextAlign.left,
    TextAlign.right,
  ];

  // Method to switch the text alignment
  void _switchTextAlignment() {
    setState(() {
      _textAlign = (_textAlign + 1) % _textAlignments.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Watch the ColorNotifier to get the current state
    final colorNotifier = context.watch<ColorNotifier>();

    // Get the current color index from the notifier
    final currentColorIndex = colorNotifier.currenColor;

    // Retrieve the background color object using the current color index
    final currentColor = colorNotifier.colors[currentColorIndex];

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        // Set the system naviagtion bar color based on the theme's surface color
        systemNavigationBarColor: Theme.of(context).colorScheme.surface,
        // Adjust the naviagtion bar icon brightness based on the theme brightness
        systemNavigationBarIconBrightness:
            Theme.of(context).brightness == Brightness.dark
                ? Brightness.light
                : Brightness.dark,
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Capy"),
          actions: [
            // Button to switch the background color
            IconButton(
              onPressed: () => colorNotifier.switchColor(),
              icon: const Icon(
                Icons.palette_rounded,
              ),
            ),

            // Button to switch the text alignment
            IconButton(
              onPressed: () => _switchTextAlignment(),
              icon: const Icon(
                Icons.align_horizontal_center_rounded,
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Screenshot(
            controller: _screenshotController,
            child: Container(
              // Container with gradient background and rounded corners
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24.0),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    currentColor.begin,
                    currentColor.end,
                  ],
                ),
              ),
              child: CaptionInput(
                textEditingController: _textEditingController,
                textAlign: _textAlignments[_textAlign],
                onChanged: (v) => setState(() {}),
              ),
            ),
          ),
        ),
        floatingActionButton: _textEditingController.text.trim().isEmpty
            ? null
            : FloatingActionButton(
                onPressed: () => _capture(),
                child: const Icon(
                  Icons.check_rounded,
                ),
              ),
      ),
    );
  }

  // Method to capture screenshot and save to gallery
  _capture() async {
    // Show a loading dialog to inform the user that the process is ongoing
    _showLoadingDialog();

    try {
      // Capture the screenshot after a short delay to ensure UI elements are fully rendered
      final bytes = await _screenshotController.capture(
        delay: const Duration(seconds: 3),
      );

      if (bytes != null) {
        // If the screenshot is successfully captured, save the image
        await _save(bytes).then(
          (_) {
            // Close the loading dialog once the save operation is complete
            Navigator.pop(context);

            // show a snackbar message to inform the user that the image is saved successfully
            _showSnackBar("Saved successfully to gallery");

            setState(() {
              // Clear the text input field
              _textEditingController.clear();
            });
          },
        );
      }
    } catch (e) {
      // If an error occurs during the screenshot capture or save operation
      _showSnackBar("Error: $e");
    }
  }

  void _showLoadingDialog() => showDialog(
        context: context,
        barrierDismissible:
            false, // Prevent dismissal by tapping outside the dialog
        builder: (BuildContext context) {
          return const AlertDialog(
            title: Text("Please wait..."),
            content: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(strokeCap: StrokeCap.round),
                SizedBox(width: 20),
                Text("Saving to gallery."),
              ],
            ),
          );
        },
      );

  Future<void> _save(Uint8List bytes) async {
    // Save the image to the device's gallery using ImageGallerySaver library
    await ImageGallerySaver.saveImage(
      bytes,
      quality: 100,
      name: _getFirstFiveWords(
        _textEditingController.text.trim(),
      ),
    );
  }

  String _getFirstFiveWords(String text) {
    // Split the input text into a list of words using space as a delimiter
    final words = text.split(' ');

    // Check if the list contains more than five words
    if (words.length > 5) {
      // If more than five words, take the first five words and join them back into a string
      return words.take(5).join(' ');
    } else {
      return text;
    }
  }

  void _showSnackBar(String s) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(s),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
