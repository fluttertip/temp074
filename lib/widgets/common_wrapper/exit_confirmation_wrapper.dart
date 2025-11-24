import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ExitConfirmationWrapper extends StatelessWidget {
  final Widget child;
  final String titleMessage;
  final String contentMessage;
  final bool forceExit;

  const ExitConfirmationWrapper({
    super.key,
    required this.child,
    required this.titleMessage,
    required this.contentMessage,
    required this.forceExit,
  });

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (forceExit) {
          // showing only warning but dont exit

          await showDialog<void>(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(titleMessage),
              content: Text(contentMessage),
              actions: [
                TextButton(
                  onPressed: () =>
                      Navigator.of(context).pop(), // closing only the dialog
                  child: const Text('OK'),
                ),
              ],
            ),
          );
          return false; // Prevent back navigation
        } else {
          // exit confirmation
          final shouldExit = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(titleMessage),
              content: Text(contentMessage),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    SystemNavigator.pop(); // Exit app
                  },
                  child: const Text('Exit'),
                ),
              ],
            ),
          );
          return shouldExit ?? false;
        }
      },
      child: child,
    );
  }
}
