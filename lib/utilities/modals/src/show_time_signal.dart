part of modals;

class ShowTimeSignal {
  static void five(BuildContext context) {
    _showSignal(context, AssetImage('signals/five.png'));
  }

  static void four() {}
  static void three() {}
  static void two() {}
  static void one() {}
  static void fist() {}
  static void thirty() {}
  static void fifteen() {}

  static void _showSignal(BuildContext context, AssetImage image) {
    if (Platform.isIOS) {
      showCupertinoModalPopup(
        context: context,
        builder: (context) => CupertinoPopupSurface(
          child: Image(image: image),
        ),
      );
    } else if (Platform.isAndroid) {
    } else {
      throw PlatformException(code: "Unsupported platform.");
    }
  }
}
