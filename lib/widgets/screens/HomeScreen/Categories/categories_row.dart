import 'package:flutter/material.dart';
import 'package:yts_flutter/widgets/screens/HomeScreen/Categories/category_card.dart';
import 'package:yts_flutter/widgets/screens/HomeScreen/Categories/categories_row_model.dart';
import 'package:yts_flutter/widgets/screens/HomeScreen/home_screen.dart';

class CategoriesRow extends StatelessWidget {
  const CategoriesRow({
    super.key,
    required this.model,
  });

  final CategoriesRowModel model;

  @override
  Widget build(BuildContext context) {
    return HomeViewSection(
        title: "Categories",
        widget: SizedBox(
          height: 140,
          child: Center(
              child: ListView.separated(
            scrollDirection: Axis.horizontal,
            // Space the cards out a bit
            padding: const EdgeInsets.all(8),
            separatorBuilder: (context, index) => const SizedBox(width: 6),
            itemCount: model.categories.length,
            itemBuilder: (context, index) =>
                CategoryCard(category: model.categories[index]),
          )),
        ));
  }
}
