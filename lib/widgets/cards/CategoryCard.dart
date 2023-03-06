import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:yts_flutter/Classes/Category.dart';
import 'package:yts_flutter/widgets/helpers/BaseCard.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({super.key, required this.category});
  final Category category;

  @override
  Widget build(BuildContext context) {
    return BaseCard(
        dimentions: (width: 200, height: 140),
        // constraints: BoxConstraints(minWidth: 200),
        inkWell: InkWell(),
        children: [
          Container(
              constraints: BoxConstraints(minWidth: 200),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color.fromARGB(255, 24, 33, 48),
                    Color.fromARGB(255, 74, 91, 130),
                  ],
                ),
              ),
              child: Center(
                child: Text(
                  category.displayName,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              )),
        ]
    );
  }
}
