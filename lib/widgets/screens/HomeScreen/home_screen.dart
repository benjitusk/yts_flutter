import 'package:flutter/material.dart';
import 'package:yts_flutter/widgets/screens/HomeScreen/Categories/categories_row.dart';
import 'package:yts_flutter/widgets/screens/HomeScreen/Rebbeim/rebbeim_row.dart';
import 'package:yts_flutter/widgets/screens/HomeScreen/Recents/recent_shiurim_row.dart';
import 'package:yts_flutter/widgets/screens/HomeScreen/home_screen_modal.dart';
import 'package:yts_flutter/widgets/helpers/Constants.dart';
import 'package:yts_flutter/widgets/helpers/TextDivider.dart';
import 'package:yts_flutter/widgets/screens/HomeScreen/Slideshow/slideshow_row.dart';

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
              ListenableBuilder(
                listenable: model.recentShiurimModel,
                builder: (context, _) =>
                    RecentShiurimRow(model: model.recentShiurimModel),
              ),
              ListenableBuilder(
                listenable: model.rebbeimRowModel,
                builder: (context, _) =>
                    RebbeimRow(model: model.rebbeimRowModel),
              ),
              ListenableBuilder(
                listenable: model.categoriesRowModel,
                builder: (context, _) =>
                    CategoriesRow(model: model.categoriesRowModel),
              ),
              ListenableBuilder(
                listenable: model.slideshowRowModel,
                builder: (context, _) =>
                    SlideshowRow(model: model.slideshowRowModel),
              ),
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
