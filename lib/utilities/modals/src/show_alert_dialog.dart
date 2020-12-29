// Copyright (c) 2020, Justin Shaw. Use of this source code is restricted,
// please read the LICENSE file for details. All rights reserved.

part of modals;

class ShowAlertDialog {
  static void withOneAction(
    BuildContext context, {
    String title,
    String content,
    String actionLabel,
    void Function() action,
  }) {
    _showPlatformAwareModalAlert(
      context: context,
      title: title,
      content: content,
      iOSActions: [
        CupertinoDialogAction(
          onPressed: () {
            HapticFeedback.selectionClick();
            action?.call();
            Navigator.of(context).pop();
          },
          child: Text(actionLabel),
        )
      ],
      androidActions: [
        TextButton(
          onPressed: () {
            HapticFeedback.selectionClick();
            action?.call();
            Navigator.of(context).pop();
          },
          child: Text(actionLabel),
        )
      ],
    );
  }

  static void withTwoBasicActions(
    BuildContext context, {
    String title,
    String content,
    String firstActionLabel,
    String secondActionLabel,
    void Function() firstAction,
    void Function() secondAction,
  }) {
    _showPlatformAwareModalAlert(
      context: context,
      title: title,
      content: content,
      iOSActions: [
        CupertinoDialogAction(
          onPressed: () {
            HapticFeedback.selectionClick();
            firstAction?.call();
            Navigator.of(context).pop();
          },
          child: Text(firstActionLabel),
        ),
        CupertinoDialogAction(
          onPressed: () {
            HapticFeedback.selectionClick();
            secondAction?.call();
            Navigator.of(context).pop();
          },
          child: Text(secondActionLabel),
        )
      ],
      androidActions: [
        TextButton(
          onPressed: () {
            HapticFeedback.selectionClick();
            firstAction?.call();
            Navigator.of(context).pop();
          },
          child: Text(firstActionLabel),
        ),
        TextButton(
          onPressed: () {
            HapticFeedback.selectionClick();
            secondAction?.call();
            Navigator.of(context).pop();
          },
          child: Text(secondActionLabel),
        )
      ],
    );
  }

  static void withDestructiveAndBasicActions(
    BuildContext context, {
    String title,
    String content,
    String destructiveActionLabel,
    String cancelActionLabel,
    void Function() destructiveAction,
    void Function() cancelAction,
  }) {
    _showPlatformAwareModalAlert(
      context: context,
      title: title,
      content: content,
      iOSActions: [
        CupertinoDialogAction(
          onPressed: () {
            HapticFeedback.selectionClick();
            cancelAction?.call();
            Navigator.of(context).pop();
          },
          child: Text(cancelActionLabel),
        ),
        CupertinoDialogAction(
          isDestructiveAction: true,
          onPressed: () {
            HapticFeedback.selectionClick();
            destructiveAction?.call();
            Navigator.of(context).pop();
          },
          child: Text(destructiveActionLabel),
        )
      ],
      androidActions: [
        TextButton(
          onPressed: () {
            HapticFeedback.selectionClick();
            cancelAction?.call();
            Navigator.of(context).pop();
          },
          child: Text(cancelActionLabel),
        ),
        TextButton(
          onPressed: () {
            HapticFeedback.selectionClick();
            destructiveAction?.call();
            Navigator.of(context).pop();
          },
          child: Text(
            destructiveActionLabel,
            style: TextStyle(
              color: Colors.red,
            ),
          ),
        )
      ],
    );
  }

  static void withDefaultAndBasicActions(
    BuildContext context, {
    String title,
    String content,
    String defaultActionLabel,
    String secondaryActionLabel,
    void Function() defaultAction,
    void Function() secondaryAction,
  }) {
    _showPlatformAwareModalAlert(
      context: context,
      title: title,
      content: content,
      iOSActions: [
        CupertinoDialogAction(
          onPressed: () {
            HapticFeedback.selectionClick();
            secondaryAction?.call();
            Navigator.of(context).pop();
          },
          child: Text(secondaryActionLabel),
        ),
        CupertinoDialogAction(
          isDefaultAction: true,
          onPressed: () {
            HapticFeedback.selectionClick();
            defaultAction?.call();
            Navigator.of(context).pop();
          },
          child: Text(defaultActionLabel),
        )
      ],
      androidActions: [
        TextButton(
          onPressed: () {
            HapticFeedback.selectionClick();
            secondaryAction?.call();
            Navigator.of(context).pop();
          },
          child: Text(secondaryActionLabel),
        ),
        TextButton(
          onPressed: () {
            HapticFeedback.selectionClick();
            defaultAction?.call();
            Navigator.of(context).pop();
          },
          child: Text(
            defaultActionLabel,
            style: TextStyle(
              color: Colors.blue,
            ),
          ),
        )
      ],
    );
  }

  static void _showPlatformAwareModalAlert({
    BuildContext context,
    String title,
    String content,
    List<Widget> iOSActions,
    List<Widget> androidActions,
  }) {
    PlatformInfo platform = Provider.of<PlatformInfo>(context, listen: false);
    if (platform.isIOS) {
      showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: Text(title),
          content: Text(
            content,
            style: TextStyle(height: 2),
          ),
          actions: iOSActions,
        ),
      );
    } else if (platform.isAndroid) {
      showGeneralDialog(
        context: context,
        pageBuilder: (context, animation, secondaryAnimation) => AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: androidActions,
        ),
      );
    } else {
      throw PlatformException(code: 'showDialog not defined for all platforms');
    }
  }
}
