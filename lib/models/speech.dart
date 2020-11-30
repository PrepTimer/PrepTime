import 'package:flutter/material.dart';

class Speech {
  AnimationController controller;
  String name;
  bool shouldCountUp;
  bool useJudgeAssistant;

  /// Starts the speech animation.
  void startSpeech() {}

  /// Pauses the speech animation.
  void pauseSpeech() {}

  /// Resumes the speech animation.
  void resumeSpeech() {}

  /// Cancels the speech animation.
  void cancelSpeech() {
    _checkControllerNotNull();
    // controller
  }

  /// Returns the speech animation's duration.
  ///
  /// Throws ArgumentError if the controller is null.
  Duration getTime() {
    _checkControllerNotNull();
    return controller.duration * controller.value;
  }

  ///
  void initController() {}

  ///
  void disposeController() {}

  /// Checks that the controller is not null.
  ///
  /// If the controller is null, throws ArgumentError.
  void _checkControllerNotNull() {
    if (controller == null) {
      throw ArgumentError('Controller should not be null.');
    }
  }
}
