import 'package:flutter/material.dart';
import 'package:yts_flutter/Classes/Shiur.dart';
import 'package:yts_flutter/widgets/helpers/Constants.dart';

const _defaultCardWidth = 200.0;

class HomeShiurCard extends StatelessWidget {
  const HomeShiurCard({super.key, required this.shiur});
  final Shiur shiur;
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
      width: _defaultCardWidth,
      constraints: BoxConstraints(minWidth: _defaultCardWidth),
      child: ClipRRect(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          borderRadius: BorderRadius.circular(12),
          child: Stack(children: [
            Positioned.fill(
                child: Material(
              color: Colors.transparent,
              child: InkWell(
                  // splashColor: Colors.white.withOpacity(0.5),
                  // onTap: () {
                  //   Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => RabbiPage(rabbi: rabbi)),
                  //   );
                  // },
                  ),
            )),
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
          ])),
    ));
  }
}
