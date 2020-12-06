import 'package:flutter/material.dart';

class PrepTimers extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        PrepTimer(),
        PrepTimer(),
      ],
    );
  }
}
