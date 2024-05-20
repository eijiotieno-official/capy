import 'package:capy/components/caption_input.dart';
import 'package:capy/models/background_color.dart';
import 'package:capy/notifiers/colors_notifier.dart';
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
  // Declaring a TextEditingController as final since it won't be reassigned
  final TextEditingController _textEditingController = TextEditingController();

  // Utility method to get the first five words of a text
  String _getFirstFiveWords(String text) {
    // Split the input text into a list of words using space as a delimiter
    final words = text.split(' ');

    // Check if the list contains more than five words
    if (words.length > 5) {
      // If more than five words, take the first five words and join them back into a string
      return words.take(5).join(' ');
    } else {
      // If five words or fewer, return the original text
      return text;
    }
  }

  // Controller for capturing screenshots
  final ScreenshotController _screenshotController = ScreenshotController();

  // Method to capture screenshot and save to gallery
  Future<void> _capture() async {
    // Show a loading dialog to inform the user that the process is ongoing
    _showLoadingDialog();

    try {
      // Capture the screenshot after a short delay to ensure UI elements are fully rendered
      final bytes = await _screenshotController.capture(
        delay: const Duration(milliseconds: 100),
      );

      if (bytes != null) {
        // If the screenshot is successfully captured, save the image
        await _save(bytes).then(
          (_) {
            // Close the loading dialog once the save operation is complete
            Navigator.pop(context);
            // Show a snackbar message to inform the user that the image is saved successfully
            _showSnackBar('Saved successfully to gallery');
            setState(() {
              // Clear the text input field
              _textEditingController.clear();
            });
          },
        );
      }
    } catch (e) {
      // If an error occurs during the screenshot capture or save operation
      if (mounted) {
        // Ensure the context is still valid before showing a snackbar
        _showSnackBar('Error: $e'); // Show an error message
      }
    }
  }

  // Method to show a loading dialog
  void _showLoadingDialog() => showDialog(
        context: context, // Context of the current widget
        barrierDismissible:
            false, // Prevent dismissal by tapping outside the dialog
        builder: (BuildContext context) {
          // Builder function to build the dialog UI
          // AlertDialog to show the loading message
          return const AlertDialog(
            title: Text("Please wait... "), // Title of the dialog
            content: Padding(
              padding: EdgeInsets.all(20.0), // Padding around the content
              child: Row(
                mainAxisSize: MainAxisSize
                    .min, // Row should take minimum horizontal space
                children: [
                  // CircularProgressIndicator to indicate loading
                  CircularProgressIndicator(
                    strokeCap: StrokeCap
                        .round, // Use round stroke for the progress indicator
                  ),
                  SizedBox(
                      width:
                          16.0), // SizedBox for spacing between CircularProgressIndicator and text
                  Text(
                      "Saving to gallery"), // Text indicating the process being performed
                ],
              ),
            ),
          );
        },
      );

  // Method to show a snackbar with a message
  void _showSnackBar(String message) {
    // Access the ScaffoldMessenger for the current context to show the snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      // Create a SnackBar widget to display a brief message at the bottom of the screen
      SnackBar(
        // Set the content of the snackbar to the provided message
        content: Text(message),
        // Set the duration for which the snackbar will be displayed on the screen
        duration: const Duration(seconds: 3), // Duration of 3 seconds
      ),
    );
  }

  // Method to save the captured image to the gallery
  Future<void> _save(Uint8List bytes) async {
    // Save the image to the device's gallery using ImageGallerySaver library
    await ImageGallerySaver.saveImage(
      bytes, // The bytes representing the image data
      quality: 100, // Set the image quality to 100 (maximum quality)
      name: _getFirstFiveWords(_textEditingController.text
          .trim()), // Specify a meaningful name for the image
    );
  }

  // Index to track text alignment
  int _textAlign = 0;

  // List of available text alignments
  final List<TextAlign> _textAlignments = [
    TextAlign.center,
    TextAlign.left,
    TextAlign.right,
  ];

  // Method to switch the text alignment
  void _switchTextAlign() {
    setState(() {
      // Increment the current text alignment index and cycle through the text alignments
      _textAlign = (_textAlign + 1) % _textAlignments.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Watch the ColorsNotifier to get the current state
    final colorNotifier = context.watch<ColorsNotifier>();

    // Get the current color index from the notifier
    final currentColor = colorNotifier.currentColor;

    // Retrieve the BackgroundColor object using the current color index
    BackgroundColor backgroundColor = colorNotifier.colors[currentColor];

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        // Set the system navigation bar color based on the theme's surface color
        systemNavigationBarColor: Theme.of(context).colorScheme.surface,
        // Adjust the navigation bar icon brightness based on the theme brightness
        systemNavigationBarIconBrightness:
            Theme.of(context).brightness == Brightness.dark
                ? Brightness.light
                : Brightness.dark,
      ),
      child: Scaffold(
        // Scaffold widget to provide the basic material design layout
        appBar: AppBar(
          // App bar with title and actions
          title: const Text("Capy"),
          actions: [
            // Button to switch the background color
            IconButton(
              onPressed: () => colorNotifier.switchColor(),
              icon: const Icon(Icons.palette_rounded),
            ),
            // Button to switch the text alignment
            IconButton(
              onPressed: () => _switchTextAlign(),
              icon: Icon(
                // Choose the icon based on the current text alignment
                _textAlign == 0
                    ? Icons.align_horizontal_center_rounded
                    : _textAlign == 1
                        ? Icons.align_horizontal_left_rounded
                        : Icons.align_horizontal_right_rounded,
              ),
            ),
          ],
        ),
        body: Padding(
          padding:
              const EdgeInsets.all(8.0), // Padding around the entire content
          child: Screenshot(
            // Screenshot widget to capture the screen content
            controller:
                _screenshotController, // Assigns the screenshot controller
            child: Container(
              // Container with gradient background and rounded corners
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24.0), // Rounded corners
                gradient: LinearGradient(
                  // Linear gradient background from top-left to bottom-right
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    backgroundColor.begin, // Start color of the gradient
                    backgroundColor.end, // End color of the gradient
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

        // Conditionally display the floating action button
        floatingActionButton: _textEditingController.text.trim().isEmpty
            ? null // If the text input is empty, do not display the floating action button
            : FloatingActionButton(
                // Button to capture the screenshot
                onPressed: () =>
                    _capture(), // Calls the _capture method when pressed
                child: const Icon(Icons.check_rounded), // Icon for the button
              ),
      ),
    );
  }
}
