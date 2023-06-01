import 'package:flutter/material.dart';
import 'package:yts_flutter/widgets/screens/HomeScreen/categories_row.dart';
import 'package:yts_flutter/widgets/screens/HomeScreen/rebbeim_row.dart';
import 'package:yts_flutter/widgets/screens/HomeScreen/recent_shiurim_row.dart';
import 'package:yts_flutter/widgets/screens/home_screen_modal.dart';
import 'package:yts_flutter/widgets/helpers/Constants.dart';
import 'package:yts_flutter/widgets/helpers/TextDivider.dart';
import 'package:yts_flutter/widgets/screens/HomeScreen/slideshow_row.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({
    Key? key,
    required this.model,
  }) : super(key: key);

  final HomeScreenModel model;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
        listenable: model,
        builder: (context, _) {
          return ListView(
            children: [
              RecentShiurimRow(model: model.recentShiurimModel),
              RebbeimRow(model: model.rebbeimRowModel),
              CategoriesRow(model: model.categoriesRowModel),
              SlideshowRow(model: model.slideshowRowModel)
            ],
          );
        });
  }
}

class HomeViewSection extends StatelessWidget {
  const HomeViewSection({super.key, required this.title, required this.widget});
  final String title;
  final Widget widget;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(UI.PAGE_PADDING),
          child: TextDivider(title),
        ),
        widget
      ],
    );
  }
}
