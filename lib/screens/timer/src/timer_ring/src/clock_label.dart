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
    Event event = context.watch<Event>();
    Speech speech = context.select((Speech newSpeech) {
      return event.speech == newSpeech ? newSpeech : event.speech;
    });
    print('Building clock label for ' + speech.name + '...');
    bool isDisabled = (event is DebateEvent) && event.isAnyRunning;
    return PageView.builder(
      scrollDirection: Axis.horizontal,
      physics: BouncingScrollPhysics(),
      controller: controller,
      onPageChanged: _updateNextOrPrevSpeech,
      itemBuilder: (context, index) {
        return Container(
          alignment: FractionalOffset.center,
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: AutoSizeText(
            _getTimeRemaining(index, speech),
            maxLines: 1,
            style: isDisabled
                ? Theme.of(context).textTheme.headline2
                : Theme.of(context).textTheme.headline1,
          ),
        );
      },
    );
  }

  void _updateNextOrPrevSpeech(int newPageIndex) {
    DebateEvent event = Provider.of<Event>(context, listen: false);
    if (newPageIndex > currentPageIndex) {
      event.nextSpeech();
    } else if (newPageIndex < currentPageIndex) {
      event.prevSpeech();
    }
    setState(() {
      currentPageIndex = newPageIndex;
    });
  }

  String _getTimeRemaining(int index, Speech speech) {
    List<Speech> speeches = _getListOfSpeechesFromEvent(context.read<Event>());
    if (speech != speeches[index]) {
      speech = speeches[index];
    }
    return _getTimeRemainingFromSpeech(speech);
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

  String _getTimeRemainingFromSpeech(Speech speech) {
    return speech.timeRemaining.toStringAsClock();
  }
}
