import 'package:flutter/material.dart';
import 'package:yts_flutter/widgets/screens/HomeScreen/Rebbeim/home_rabbi_card.dart';
import 'package:yts_flutter/widgets/screens/HomeScreen/Rebbeim/rebbeim_row_model.dart';
import 'package:yts_flutter/widgets/screens/HomeScreen/home_screen.dart';

class RebbeimRow extends StatelessWidget {
  const RebbeimRow({
    super.key,
    required this.model,
  });

  final RebbeimRowModel model;

  @override
  Widget build(BuildContext context) {
    return HomeViewSection(
        title: "Rebbeim",
        widget: SizedBox(
          height: 156,
          child: Center(
              child: ListView.separated(
            padding: const EdgeInsets.all(8.0),
            scrollDirection: Axis.horizontal,
            separatorBuilder: (context, index) => const SizedBox(width: 6),
            itemCount: model.rebbeim.length,
            itemBuilder: (context, index) =>
                HomeRabbiCard(rabbi: model.rebbeim[index]),
          )),
        ));
  }
}
