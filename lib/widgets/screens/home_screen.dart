import 'package:flutter/material.dart';
import 'package:yts_flutter/widgets/screens/home_screen_modal.dart';
import 'package:yts_flutter/widgets/slideshow.dart';
import 'package:yts_flutter/widgets/cards/category_card.dart';
import 'package:yts_flutter/widgets/cards/home_rabbi_card.dart';
import 'package:yts_flutter/widgets/cards/home_shiur_card.dart';
import 'package:yts_flutter/widgets/helpers/Constants.dart';
import 'package:yts_flutter/widgets/helpers/TextDivider.dart';

class HomePage extends StatelessWidget {
  HomePage({
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
              HomeViewSection(
                  title: "Recent Shiurim",
                  widget: SizedBox(
                    height: 137,
                    child: Center(
                        child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      // Space the cards out a bit
                      padding: const EdgeInsets.all(8),
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 6),
                      itemCount: model.recentShiurim.length,
                      itemBuilder: (context, index) =>
                          HomeShiurCard(shiur: model.recentShiurim[index]),
                    )),
                  )),
              HomeViewSection(
                  title: "Rebbeim",
                  widget: SizedBox(
                    height: 156,
                    child: Center(
                        child: ListView.separated(
                      padding: const EdgeInsets.all(8.0),
                      scrollDirection: Axis.horizontal,
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 6),
                      itemCount: model.rebbeim.length,
                      itemBuilder: (context, index) =>
                          HomeRabbiCard(rabbi: model.rebbeim[index]),
                    )),
                  )),
              HomeViewSection(
                  title: "Categories",
                  widget: SizedBox(
                    height: 140,
                    child: Center(
                        child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      // Space the cards out a bit
                      padding: const EdgeInsets.all(8),
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 6),
                      itemCount: model.categories.length,
                      itemBuilder: (context, index) =>
                          CategoryCard(category: model.categories[index]),
                    )),
                  )),
              HomeViewSection(
                  title: "Featured Pictures",
                  widget: ImageCarousel(
                    urls: model.featuredImageURLs,
                  ))
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
