part of modals;

class Alerts {
  static void showAlertDialogWithTwoOptions(
    BuildContext context, {
    String title,
    String content,
    String destructiveActionLabel,
    String cancelActionLabel,
    void Function() destructiveAction,
    void Function() cancelAction,
  }) {
    if (Platform.isIOS) {
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            CupertinoDialogAction(
              onPressed: cancelAction,
              child: Text(cancelActionLabel),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              onPressed: destructiveAction,
              child: Text(destructiveActionLabel),
            )
          ],
        ),
      );
    } else if (Platform.isAndroid) {
      showGeneralDialog(
        context: context,
        pageBuilder: (context, animation, secondaryAnimation) => AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: cancelAction,
              child: Text(cancelActionLabel),
            ),
            TextButton(
              onPressed: destructiveAction,
              child: Text(
                destructiveActionLabel,
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            )
          ],
        ),
      );
    } else {
      throw PlatformException(code: 'showDialog not defined for all platforms');
    }
  }
}
