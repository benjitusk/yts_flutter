import 'package:flutter/material.dart';
import 'package:text_scroll/text_scroll.dart';

class MarqueeText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final double? width;
  final double speed;
  MarqueeText(
      {super.key, required this.text, this.style, this.width, this.speed = 1});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      child: TextScroll(
        text,
        pauseBetween: Duration(seconds: 1, milliseconds: 500), // 1.5 sec
        fadedBorder: true,
        fadeBorderSide: FadeBorderSide.right,
        fadedBorderWidth: 0.1,
        velocity: Velocity(pixelsPerSecond: Offset(50 * speed, 0)),
        // blankSpace: 20.0,
        // velocity: ,
        // pauseBetween: Duration(seconds: 2),
        // startPadding: 10.0,
        style: style,
      ),
    );
  }
}
