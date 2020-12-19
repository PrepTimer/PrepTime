import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:preptime/models/debate_event.dart';
import 'package:preptime/models/event.dart';
import 'package:preptime/models/speech.dart';
import 'package:preptime/models/speech_event.dart';
import 'package:provider/provider.dart';
import 'package:preptime/utilities/duration_format/duration_format.dart';

/// The amount of time left on the clock.
class ClockLabel extends StatefulWidget {
  ClockLabel({Key key}) : super(key: key);
  @override
  _ClockLabelState createState() => _ClockLabelState();
}

class _ClockLabelState extends State<ClockLabel> {
  PageController controller;
  int currentPageIndex = 0;

  @override
  initState() {
    super.initState();
    controller = PageController();
  }

  @override
  dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDisabled = _isSpeechDisabledFromEvent(context.watch<Event>());
    List<Speech> speeches = _getListOfSpeechesFromEvent(context.watch<Event>());
    return PageView.builder(
      scrollDirection: Axis.horizontal,
      physics: ClampingScrollPhysics(),
      controller: controller,
      onPageChanged: _updateNextOrPrevSpeech,
      itemBuilder: (context, index) {
        return Container(
          alignment: FractionalOffset.center,
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: AutoSizeText(
            speeches[index].timeRemaining.toStringAsClock(),
            maxLines: 1,
            style: isDisabled
                ? Theme.of(context).textTheme.headline2
                : Theme.of(context).textTheme.headline1,
          ),
        );
      },
    );
  }

  List<Speech> _getListOfSpeechesFromEvent(Event event) {
    List<Speech> speeches = List();
    if (event is SpeechEvent) {
      speeches.add(event.speech);
    } else if (event is DebateEvent) {
      for (Speech speech in event.speeches) {
        speeches.add(speech);
      }
    }
    return speeches;
  }

  bool _isSpeechDisabledFromEvent(Event event) {
    return (event is DebateEvent) && event.isAnyRunning;
  }

  void _updateNextOrPrevSpeech(int newPageIndex) {
    Event event = context.read<Event>();
    setState(() {
      if (newPageIndex > currentPageIndex) {
        event.nextSpeech();
      } else if (newPageIndex < currentPageIndex) {
        event.prevSpeech();
      }
      currentPageIndex = newPageIndex;
    });
  }
}
