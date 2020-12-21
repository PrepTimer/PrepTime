part of modals;

class Alerts {
  static void showAlertDialogWithTwoBasicOptions(
    BuildContext context, {
    String title,
    String content,
    String firstActionLabel,
    String secondActionLabel,
    void Function() firstAction,
    void Function() secondAction,
  }) {
    if (Platform.isIOS) {
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: Text(title),
          content: Text(
            content,
            style: TextStyle(height: 2),
          ),
          actions: [
            CupertinoDialogAction(
              onPressed: firstAction,
              child: Text(firstActionLabel),
            ),
            CupertinoDialogAction(
              onPressed: secondAction,
              child: Text(secondActionLabel),
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
              onPressed: firstAction,
              child: Text(firstActionLabel),
            ),
            TextButton(
              onPressed: secondAction,
              child: Text(secondActionLabel),
            )
          ],
        ),
      );
    } else {
      throw PlatformException(code: 'showDialog not defined for all platforms');
    }
  }

  static void showAlertDialogWithOneDestructiveOption(
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
          content: Text(
            content,
            style: TextStyle(height: 2),
          ),
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

  static void showAlertDialogWithOneDefaultOption(
    BuildContext context, {
    String title,
    String content,
    String defaultActionLabel,
    String secondaryActionLabel,
    void Function() defaultAction,
    void Function() secondaryAction,
  }) {
    if (Platform.isIOS) {
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: Text(title),
          content: Text(
            content,
            style: TextStyle(height: 2),
          ),
          actions: [
            CupertinoDialogAction(
              onPressed: secondaryAction,
              child: Text(secondaryActionLabel),
            ),
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: defaultAction,
              child: Text(defaultActionLabel),
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
              onPressed: secondaryAction,
              child: Text(secondaryActionLabel),
            ),
            TextButton(
              onPressed: defaultAction,
              child: Text(
                defaultActionLabel,
                style: TextStyle(
                  color: Colors.blue,
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
