import 'package:flutter/material.dart';
import 'package:yts_flutter/widgets/screens/HomeScreen/home_screen.dart';
import 'package:yts_flutter/widgets/screens/HomeScreen/Slideshow/slideshow.dart';
import 'package:yts_flutter/widgets/screens/HomeScreen/Slideshow/slideshow_row_model.dart';

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
