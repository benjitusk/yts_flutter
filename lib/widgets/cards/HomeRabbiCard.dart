import 'dart:ui';

import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/container.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter/src/widgets/placeholder.dart';
import 'package:yts_flutter/Classes/Author.dart';
import 'package:yts_flutter/widgets/pages/RabbiPage.dart';

const double _defaultCardDimentions = 140;

class HomeRabbiCard extends StatelessWidget {
  final Author rabbi;
  const HomeRabbiCard({super.key, required this.rabbi});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
      width: _defaultCardDimentions,
      height: _defaultCardDimentions,
      constraints: const BoxConstraints(
          maxWidth: _defaultCardDimentions,
          maxHeight: _defaultCardDimentions,
          minHeight: _defaultCardDimentions,
          minWidth: _defaultCardDimentions),
      child: ClipRRect(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          borderRadius: BorderRadius.circular(12),
          child: Stack(children: [
            Image.network(rabbi.profilePictureURL,
                fit: BoxFit.cover,
                width: _defaultCardDimentions,
                height: _defaultCardDimentions),
            Positioned.fill(
                child: Material(
              color: Colors.transparent,
              child: InkWell(
                // splashColor: Colors.white.withOpacity(0.5),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RabbiPage(rabbi: rabbi)),
                  );
                },
              ),
            )),
            Align(
              alignment: Alignment.bottomLeft,
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.only(topRight: Radius.circular(12)),
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                    child: Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Text(
                        rabbi.name,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ])),
    ));
  }
}
