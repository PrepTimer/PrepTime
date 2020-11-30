import 'dart:async';

import 'package:preptime/models/event.dart';
import 'package:preptime/models/team.dart';

mixin PrepTimeMixin on Event {
  Timer leftPrep;
  Timer rightPrep;

  void startPrep(Team t) {

  }

  void stopPrep(Team t) {

  }

  void resetPrep(Team t) {
    
  }
}
