// Copyright (c) 2020, Justin Shaw. Use of this source code is restricted,
// please read the LICENSE file for details. All rights reserved.

library modals;

import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:preptime/models/platform_info.dart';
import 'package:preptime/utilities/modals/src/time_signals/time_signals.dart';
import 'package:preptime/utilities/modals/src/time_signals/min_or_sec.dart';
import 'package:provider/provider.dart';

part 'src/show_alert_dialog.dart';
part './src/show_time_signal.dart';
