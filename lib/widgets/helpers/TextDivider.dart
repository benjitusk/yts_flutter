import 'package:flutter/material.dart';

class TextDivider extends StatelessWidget {
  const TextDivider(this.text, {super.key});
  static const dividerColor = Colors.grey;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(text,
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(color: Theme.of(context).colorScheme.primary)),
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
