import 'package:flutter/material.dart';

class BaseCard extends StatelessWidget {
  const BaseCard({super.key, this.children = const [], this.dimentions, this.constraints, this.inkWell});
  final InkWell? inkWell;
  final List<Widget> children;
  final ({double? height, double? width})? dimentions;
  final BoxConstraints? constraints;
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
      width: dimentions?.width,
      height: dimentions?.height,
      constraints: constraints,
      child: ClipRRect(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          borderRadius: BorderRadius.circular(12),
          child: Stack(children:[
            ...children,
            if (inkWell != null) Positioned.fill(
                child: Material(
              color: Colors.transparent,
              child: inkWell,
            )),
            ]),
        )));
  }
}