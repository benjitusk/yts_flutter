import 'package:flutter/material.dart';
import 'package:yts_flutter/widgets/screens/home_screen.dart';
import 'package:yts_flutter/widgets/slideshow.dart';
import 'package:yts_flutter/widgets/screens/HomeScreen/slideshow_row_model.dart';

class SlideshowRow extends StatelessWidget {
  const SlideshowRow({
    super.key,
    required this.model,
  });

  final SlideshowRowModel model;

  @override
  Widget build(BuildContext context) {
    return HomeViewSection(
        title: "Featured Pictures",
        widget: ImageCarousel(
          urls: model.featuredImageURLs,
        ));
  }
}
