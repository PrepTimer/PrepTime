import 'package:flutter/material.dart';
import 'package:preptime/models/platform_info.dart';
import 'package:preptime/theme/style.dart';
import 'mock_provider.dart';

/// Wraps the given child widget with a [MaterialApp].
///
/// This method also wraps a [PrepTimeProvider], [Scaffold], and [SafeArea]
/// around the child.
Widget materialWrapper(
  Widget child, {
  PlatformInfo platformInfo = const PlatformInfo.iOS(),
}) {
  return MockProvider(
    platformInfo: platformInfo,
    child: MaterialApp(
      theme: PrepTimeThemeData.darkTheme,
      title: 'Prep Time',
      home: Scaffold(
        backgroundColor: PrepTimeThemeData.darkTheme.backgroundColor,
        body: SafeArea(
          child: child,
        ),
      ),
    ),
  );
}
