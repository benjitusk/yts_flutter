import 'package:flutter/material.dart';

class TextDivider extends StatelessWidget {
  const TextDivider({super.key, required this.text});
  static const dividerColor = Colors.grey;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(text, style: Theme.of(context).textTheme.titleLarge),
        SizedBox(width: 8),
        Expanded(
          child: Divider(
            color: dividerColor,
            thickness: 0.51,
          ),
        ),
      ],
    );
  }
}
