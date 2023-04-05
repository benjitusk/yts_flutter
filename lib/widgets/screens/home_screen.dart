import 'package:flutter/material.dart';
import 'package:yts_flutter/classes/author.dart';
import 'package:yts_flutter/classes/category.dart';
import 'package:yts_flutter/classes/shiur.dart';
import 'package:yts_flutter/widgets/slideshow.dart';
import 'package:yts_flutter/widgets/cards/category_card.dart';
import 'package:yts_flutter/widgets/cards/home_rabbi_card.dart';
import 'package:yts_flutter/widgets/cards/home_shiur_card.dart';
import 'package:yts_flutter/widgets/helpers/Constants.dart';
import 'package:yts_flutter/widgets/helpers/TextDivider.dart';

class HomePage extends StatelessWidget {
  HomePage(
      {key,
      required this.rebbeim,
      required this.categories,
      required this.featuredImageURLs,
      required this.recentShiurim})
      : super(key: key);
  final List<Author> rebbeim;
  final List<Shiur> recentShiurim;
  final List<String> featuredImageURLs;
  final List<Category> categories;

  // This will fetch the news titles from Firebase

  @override
  Widget build(BuildContext context) {
    final sections = {
      "Recent Shiurim": SizedBox(
        height: 137,
        child: Center(
            child: ListView.separated(
          scrollDirection: Axis.horizontal,
          // Space the cards out a bit
          padding: const EdgeInsets.all(8),
          separatorBuilder: (context, index) => const SizedBox(width: 6),
          itemCount: recentShiurim.length,
          itemBuilder: (context, index) =>
              HomeShiurCard(shiur: recentShiurim[index]),
        )),
      ),
      "Rebbeim": SizedBox(
        height: 156,
        child: Center(
            child: ListView.separated(
          padding: const EdgeInsets.all(8.0),
          scrollDirection: Axis.horizontal,
          separatorBuilder: (context, index) => const SizedBox(width: 6),
          itemCount: rebbeim.length,
          itemBuilder: (context, index) => HomeRabbiCard(rabbi: rebbeim[index]),
        )),
      ),
      "Categories": SizedBox(
        height: 140,
        child: Center(
            child: ListView.separated(
          scrollDirection: Axis.horizontal,
          // Space the cards out a bit
          padding: const EdgeInsets.all(8),
          separatorBuilder: (context, index) => const SizedBox(width: 6),
          itemCount: categories.length,
          itemBuilder: (context, index) =>
              CategoryCard(category: categories[index]),
        )),
      ),
      "Featured Pictures": ImageCarousel(
        urls: featuredImageURLs,
      ),
    };
    return ListView(
      children: [
        // TextButton(onPressed: loadData, child: Text("Reload")),
        ...sections
            .map((title, widget) => MapEntry(
                title,
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(UI.PAGE_PADDING),
                      child: TextDivider(title),
                    ),
                    widget,
                  ],
                )))
            .values
      ],
    );
  }
}
