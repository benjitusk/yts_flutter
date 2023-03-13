import 'package:flutter/material.dart';

class BaseCard extends StatelessWidget {
  const BaseCard(
      {super.key, this.children = const [], this.constraints, this.onClick});
  final VoidCallback? onClick;
  final List<Widget> children;
  final BoxConstraints? constraints;
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
            constraints: constraints,
            child: ClipRRect(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              borderRadius: BorderRadius.circular(8),
              child: Stack(children: [
                ...children,
                if (onClick != null)
                  Positioned.fill(
                      child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: onClick,
                            // splashColor: Colors.black.withOpacity(0.2),
                            // highlightColor: Colors.black.withOpacity(0.1),
                          ))),
              ]),
            )));
  }
}
