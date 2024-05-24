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
            controller:
                _screenshotController, // Controller for capturing screenshots
            child: Container(
              // Container with gradient background and rounded corners
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24.0),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    currentColor.begin, // Starting color of the gradient
                    currentColor.end, // Ending color of the gradient
                  ],
                ),
              ),
              child: CaptionInput(
                textEditingController:
                    _textEditingController, // Controller for the caption input field
                textAlign: _textAlignments[
                    _textAlign], // Text alignment based on the current index
                onChanged: (v) =>
                    setState(() {}), // Callback for text input changes
              ),
            ),
          ),
        ),
        floatingActionButton: _textEditingController.text.trim().isEmpty
            ? null // If the trimmed text is empty, FAB is set to null
            : FloatingActionButton(
                // If the trimmed text is not empty, display the FAB
                onPressed: () =>
                    _capture(), // onPressed callback calls the _capture method
                child: const Icon(
                  Icons.check_rounded, // Icon for the FAB (check mark icon)
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
        // Show a loading dialog to inform the user about an ongoing process

        context:
            context, // The current BuildContext required to show the dialog

        barrierDismissible:
            false, // Prevent dismissal by tapping outside the dialog

        builder: (BuildContext context) {
          // Define the content and appearance of the dialog

          return const AlertDialog(
            // Display an AlertDialog with the specified title and content

            title: Text("Please wait..."), // Title of the dialog

            content: Row(
              mainAxisSize: MainAxisSize.min,
              // Define the size of the row based on its children

              children: [
                CircularProgressIndicator(
                    strokeCap: StrokeCap.round), // Loading indicator
                SizedBox(width: 20), // Spacing between indicator and text
                Text("Saving to gallery."), // Text content to inform the user
              ],
            ),
          );
        },
      );

  Future<void> _save(Uint8List bytes) async {
    // This method saves the image represented by the Uint8List bytes to the device's gallery.
    // It uses the ImageGallerySaver library for this purpose.
    // The method is asynchronous, as it involves IO operations, so it returns a Future<void>.

    await ImageGallerySaver.saveImage(
      bytes,
      // The bytes parameter represents the image data to be saved.
      // It's of type Uint8List, which is commonly used for image data in Flutter.

      quality: 100,
      // The quality parameter determines the quality of the saved image.
      // Here, it's set to 100, indicating the highest quality (no compression).

      name: _getFirstFiveWords(
        _textEditingController.text.trim(),
      ),
      // The name parameter specifies the filename for the saved image.
      // It's set to the result of the _getFirstFiveWords method, which truncates the text from the input field.
      // The text is trimmed to remove leading and trailing whitespaces before truncation.
    );
  }

  String _getFirstFiveWords(String text) {
    // This method extracts the first five words from the input text string.
    // If the input string contains five words or fewer, it returns the original string unchanged.

    final words = text.split(' ');
    // Split the input text into a list of words using space as a delimiter.
    // The split method returns a list of substrings, each containing a word from the input text.

    if (words.length > 5) {
      // Check if the list contains more than five words.
      // If so, it means the input text has more than five words.

      return words.take(5).join(' ');
      // Take the first five words from the list of words and join them back into a single string.
      // The take method returns the first five elements from the list, and the join method concatenates them with spaces.
      // This ensures that the resulting string contains at most the first five words from the input text.
    } else {
      // If the input text has five words or fewer, return the original string unchanged.
      return text;
    }
  }

  void _showSnackBar(String s) {
    // This method displays a snackbar with the provided message 's'.

    ScaffoldMessenger.of(context).showSnackBar(
      // Access the ScaffoldMessenger to display the snackbar.
      // ScaffoldMessenger is responsible for managing snackbars within the current scaffold.

      SnackBar(
        content: Text(s), // The text content of the snackbar.
        // Displays the provided message in the snackbar.

        duration: const Duration(
            seconds: 3), // Duration for which the snackbar is displayed.
        // The snackbar will be visible for 3 seconds before automatically dismissing.
      ),
    );
  }
}
