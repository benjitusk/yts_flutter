import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class TextDivider extends StatelessWidget {
  const TextDivider({super.key, required this.text});
  static const dividerColor = Colors.grey;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Row(
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
      ),
    );
  }
}
