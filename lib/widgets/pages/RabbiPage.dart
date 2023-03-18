import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:yts_flutter/Classes/Author.dart';
import 'package:yts_flutter/widgets/helpers/ImageCircle.dart';

class RabbiPage extends StatelessWidget {
  const RabbiPage({super.key, required this.rabbi});
  final Author rabbi;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(rabbi.name),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: CircleAvatar(
                minRadius: 25,
                backgroundImage:
                    CachedNetworkImageProvider(rabbi.profilePictureURL),
              ),
            )
          ],
        ),
        body: Placeholder());
  }
}
