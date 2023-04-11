import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:yts_flutter/classes/category.dart';
import 'package:yts_flutter/widgets/helpers/BaseCard.dart';
import 'package:yts_flutter/widgets/pages/category_page.dart';

class CategoryCard extends StatelessWidget {
  CategoryCard({super.key, required this.category});
  // static const dimentions = (width: 150.0, height: 110.0);
  final Category category;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        BaseCard(
            // constraints: BoxConstraints(maxWidth: 600),
            onClick: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => CategoryPage(category: category)),
              );
            },
            children: [
              Container(
                height: double.infinity,
                decoration: BoxDecoration(
                  image: (category.imageURL != null)
                      ? DecorationImage(
                          image: CachedNetworkImageProvider(category.imageURL!),
                          fit: BoxFit.cover)
                      : null,
                  gradient: (category.imageURL == null)
                      ? LinearGradient(
                          begin: Alignment.bottomLeft,
                          end: Alignment.topRight,
                          colors: [
                            Colors.red.withOpacity(1),
                            Colors.orange.withOpacity(1),
                          ],
                        )
                      : null,
                ),
                child: Container(
                  color: Colors.black.withOpacity(0.2),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50.0),
                    child: Center(
                      child: Text(category.displayName,
                          style: Theme.of(context)
                              .textTheme
                              .headlineLarge!
                              .copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
              ),
            ]),
      ],
    );
  }
}
