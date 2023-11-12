import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ImageCarousel extends StatelessWidget {
  const ImageCarousel({super.key, required this.urls});
  final List<String> urls;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: CarouselSlider.builder(
          itemCount: urls.length,
          itemBuilder: (context, index, realIndex) {
            return SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: urls.isEmpty
                        ? Center(child: CircularProgressIndicator())
                        : CachedNetworkImage(
                            fit: BoxFit.cover,
                            imageUrl: urls[index],
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) => Center(
                                    child: CircularProgressIndicator(
                                        value: downloadProgress.progress)),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                  )),
            );
          },
          options: CarouselOptions(
              // disableCenter: true,
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 10),
              autoPlayAnimationDuration: Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              enlargeCenterPage: true,
              scrollDirection: Axis.horizontal,
              // padEnds: false,
              viewportFraction: 1)),
      // child: CarouselSlider(
      //     items: [
      //       for (final url in urls)
      //         Container(
      //           child: Center(
      //               child: Image.network(url,
      //                   filterQuality: FilterQuality.low,
      //                   cacheHeight: 200,
      //                   cacheWidth: 200,
      //                   loadingBuilder: (context, child, loadingProgress) {
      //             if (loadingProgress == null) return child;
      //             return Center(
      //                 child: CircularProgressIndicator(
      //                     value: loadingProgress.expectedTotalBytes != null
      //                         ? loadingProgress.cumulativeBytesLoaded /
      //                             loadingProgress.expectedTotalBytes!
      //                         : null));
      //           })
      //               // Text(
      //               //     "Loading: ${(loadingProgress?.cumulativeBytesLoaded ?? 1) / (loadingProgress?.expectedTotalBytes ?? 1) * 100}%")),
      //               ),
      //         )
      //     ],
      //     options: CarouselOptions(
      //       // height: 200,
      //       autoPlay: !true,
      //       autoPlayInterval: Duration(seconds: 3),
      //       autoPlayAnimationDuration: Duration(milliseconds: 800),
      //       autoPlayCurve: Curves.fastOutSlowIn,
      //       enlargeCenterPage: true,
      //       scrollDirection: Axis.horizontal,
      //     )),
    );
  }
}
