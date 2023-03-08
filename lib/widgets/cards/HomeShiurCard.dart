import 'package:flutter/material.dart';
import 'package:yts_flutter/Classes/Shiur.dart';
import 'package:yts_flutter/widgets/helpers/BaseCard.dart';

const _defaultCardWidth = 200.0;

class HomeShiurCard extends StatelessWidget {
  const HomeShiurCard({super.key, required this.shiur});
  final Shiur shiur;
  @override
  Widget build(BuildContext context) {
    return BaseCard(
      dimentions: (width: _defaultCardWidth, height: null),
      constraints: BoxConstraints(minWidth: _defaultCardWidth),
      onClick: () {},
      children: [
            Container(
                constraints: BoxConstraints(minWidth: _defaultCardWidth),
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
                child: Column(
                  children: [
                    FittedBox(
                      child: Row(
                        children: [
                          Text(
                            shiur.title,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                          )
                        ],
                      ),
                    )
                  ],
                )),
          ]
    );
  }
}
