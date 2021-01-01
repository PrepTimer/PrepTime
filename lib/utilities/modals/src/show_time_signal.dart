// Copyright (c) 2020, Justin Shaw. Use of this source code is restricted,
// please read the LICENSE file for details. All rights reserved.

part of modals;

class ShowTimeSignal {
  static Duration _signalDuration = Duration(seconds: 2);

  static void fromDuration(Duration duration, BuildContext context) {
    TimeSignal signal;
    String message;
    if (duration.equalsMinutesOrSeconds(5)) {
      signal = TimeSignal.five;
      message = 'Five ' + duration.isMinutesOrSeconds() + 's Left';
    } else if (duration.equalsMinutesOrSeconds(4)) {
      signal = TimeSignal.four;
      message = 'Four ' + duration.isMinutesOrSeconds() + 's Left';
    } else if (duration.equalsMinutesOrSeconds(3)) {
      signal = TimeSignal.three;
      message = 'Three ' + duration.isMinutesOrSeconds() + 's Left';
    } else if (duration.equalsMinutesOrSeconds(2)) {
      signal = TimeSignal.two;
      message = 'Two ' + duration.isMinutesOrSeconds() + 's Left';
    } else if (duration.equalsMinutesOrSeconds(1)) {
      signal = TimeSignal.one;
      message = 'One ' + duration.isMinutesOrSeconds() + ' Left';
    } else if (duration == const Duration(seconds: 30)) {
      signal = TimeSignal.thirty;
      message = 'Thirty Seconds Left';
    } else if (duration == const Duration(seconds: 15)) {
      signal = TimeSignal.fifteen;
      message = 'Fifteen Seconds Left';
    } else if (duration.equalsMinutesOrSeconds(0)) {
      signal = TimeSignal.fist;
      message = "Time's up!";
    }
    if (duration <= const Duration(seconds: 5)) {
      _signalDuration = const Duration(milliseconds: 750);
    } else {
      _signalDuration = const Duration(seconds: 2);
    }
    if (signal != null) {
      String assetName = 'assets/signals/${signal.toShortString()}.png';
      _showSignal(context, AssetImage(assetName), message);
    }
  }

  static void _showSignal(BuildContext context, AssetImage image, String msg) {
    Timer(_signalDuration, () => _popModal(context));
    PlatformInfo platform = Provider.of<PlatformInfo>(context, listen: false);
    if (platform.isIOS || platform.isAndroid) {
      showCupertinoModalPopup(
        context: context,
        builder: (context) => Center(
          child: Padding(
            padding: const EdgeInsets.all(40.0),
            child: CupertinoPopupSurface(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image(
                    image: image,
                    color: Theme.of(context).textTheme.headline3.color,
                  ),
                  Text(
                    msg,
                    style: Theme.of(context).textTheme.headline3,
                  ),
                  const SizedBox(height: 20.0),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }

  static void _popModal(BuildContext context) {
    Navigator.of(context).pop();
  }
}
