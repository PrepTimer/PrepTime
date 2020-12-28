// Copyright (c) 2020, Justin Shaw. Use of this source code is restricted,
// please read the LICENSE file for details. All rights reserved.

import 'package:flutter/widgets.dart';
import 'package:preptime/models/event.dart';
import 'package:preptime/models/prep_time_mixin.dart';
import 'package:preptime/models/speech.dart';

/// A [DebateEvent] is an [Event] where multiple speechs are given.
///
/// The timer in a debate event counts down, whereas the timer in a
/// [SpeechEvent] will count up. For a [DebateEvent], the [nextSpeech] and
/// [prevSpeech] methods will change the value of the speech and trigger
/// updates in the UI. Additionally, you can use [numSpeeches] to get the
/// number of speeches in this event and [currentSpeechIndex] to get the
/// index of the current speech.
///
/// A [DebateEvent] also has a [pageController] which controlls the swiping
/// feature between speeches.
class DebateEvent extends Event with PrepTimeMixin {
  /// Controlls the clock swiping feature.
  final pageController = PageController();

  /// The list of speeches that defines a [DebateEvent].
  final List<Speech> speeches;

  /// Constructs a new [DebateEvent].
  ///
  /// The name and description parameters must not be null, and the speeches
  /// parameter must not be null or empty.
  DebateEvent({
    String name,
    String description,
    this.speeches,
  })  : assert(name != null),
        assert(description != null),
        assert(speeches != null),
        assert(speeches.isNotEmpty),
        super(name: name, description: description, speech: speeches.first);

  /// Returns the number of speeches in the debate event.
  int get numSpeeches => this.speeches.length;

  /// Returns the index of the current speech.
  int get currentSpeechIndex => speeches.indexOf(super.speech);

  /// Sets the current speech to be the next speech.
  ///
  /// Throws [RangeError] if the current speech index is less than zero or
  /// greater than the index of the last element.
  void nextSpeech() {
    if (currentSpeechIndex < 0 || currentSpeechIndex >= numSpeeches - 1) {
      throw RangeError('NextSpeech: Index out of range.');
    } else {
      super.speech = speeches[currentSpeechIndex + 1];
      notifyListeners();
    }
  }

  /// Sets the current speech to be the previous speech.
  ///
  /// Throws [RangeError] if the current speech index is greater than or equal
  /// to the last speech or if it is less than or equal to zero.
  void prevSpeech() {
    if (currentSpeechIndex <= 0 || currentSpeechIndex >= numSpeeches) {
      throw RangeError('PrevSpeech: Index out of range.');
    } else {
      super.speech = speeches[currentSpeechIndex - 1];
      notifyListeners();
    }
  }

  /// Initializes the controller.
  ///
  /// Binds the [TickerProvider] to the [AnimationController] and if the speech
  /// uses [JudgeAssistant], the controller will also add the [onStatusChange]
  /// callback to the controller. Additionally, the [onSpeechEnd] callback is
  /// added
  @override
  void initSpeechController(
    TickerProvider ticker, {
    BuildContext context,
    void Function() onSpeechEnd,
  }) {
    for (Speech speech in speeches) {
      speech.initController(ticker, context,
          onStatusChanged: (AnimationStatus status) {
        if (speech.isAnimationCompleted(status)) {
          onSpeechEnd?.call();
          _autoScroll(speech);
        }
      });
    }
  }

  /// Disposes the resources used by this [DebateEvent].
  @override
  void dispose() {
    for (Speech speech in speeches) {
      speech.dispose();
    }
    speeches.clear();
    disposePrepTimers();
    super.dispose();
  }

  /// Automatically scrolls to the next speech.
  ///
  /// This method is a no-op if useJudgeAssistant is false or if it is not safe
  /// to scroll to the next speech (the current speech is the last speech, for
  /// example).
  void _autoScroll(Speech speech) {
    if (speech.useJudgeAssistant) {
      _scrollToNextPageIfSafe();
    }
  }

  /// Scrolls to the next page if it is safe to do so.
  void _scrollToNextPageIfSafe() {
    if (pageController.hasClients && pageController.page < numSpeeches - 1) {
      pageController.nextPage(
        duration: Duration(seconds: 1),
        curve: Curves.ease,
      );
    } else if (pageController.page == numSpeeches - 1) {
      reset();
    }
  }
}
