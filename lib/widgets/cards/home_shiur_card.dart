import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:yts_flutter/classes/author.dart';
// import 'package:yts_flutter/classes/audio_manager.dart';
import 'package:yts_flutter/classes/audio_manager.dart';
import 'package:yts_flutter/classes/favorites_manager.dart';
import 'package:yts_flutter/classes/shiur.dart';
import 'package:yts_flutter/widgets/helpers/BaseCard.dart';
import 'package:yts_flutter/extensions/Duration.dart';
import 'package:intl/intl.dart';

class HomeShiurCard extends StatelessWidget {
  const HomeShiurCard({super.key, required this.shiur});
  final Shiur shiur;
  @override
  Widget build(BuildContext context) {
    return BaseCard(
        onClick: () async {
          AudioManager().showMediaPlayer(context);
          await AudioManager().loadContent(shiur);
          await AudioManager().play();
        },
        children: [
          Container(
              padding: EdgeInsets.all(10),
              constraints: BoxConstraints(minWidth: 200),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF182030),
                    Color(0xFF4A5B82),
                  ],
                ),
              ),
              child: IntrinsicWidth(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          constraints: BoxConstraints(maxWidth: 175),
                          child: Text(shiur.title,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              softWrap: true,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                        ),
                        Container(
                          child: Padding(
                            padding: EdgeInsets.only(left: 8),
                            child: (shiur.author is Author)
                                ? ClipOval(
                                    child: Container(
                                        width: 32,
                                        height: 32,
                                        // height: double.infinity,
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image: CachedNetworkImageProvider(
                                                    (shiur.author as Author)
                                                        .profilePictureURL)))))
                                : null,
                          ),
                        )
                      ],
                    ),
                    Spacer(),
                    Spacer(),
                    Row(
                      children: [
                        Text(shiur.author.name,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(color: Colors.white)),
                        Spacer(),
                        StreamBuilder(
                            stream: FavoritesManager().favoritesStream,
                            builder: (context, _) {
                              final isFavorite =
                                  FavoritesManager().isFavorite(shiur.id);

                              if (isFavorite)
                                return Icon(Icons.bookmark_added,
                                    color: Colors.white);
                              return Container();
                            }),
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Text(DateFormat.yMMMd().format(shiur.date),
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(color: Colors.white)),
                        Spacer(),
                        Row(
                          children: [
                            Icon(Icons.mic_none, color: Colors.white, size: 16),
                            SizedBox(width: 5),
                            Text(shiur.duration.toHoursMinutesSeconds(),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(color: Colors.white)),
                          ],
                        ),
                      ],
                    ),
                    Spacer()
                  ],
                ),
              )),
        ]);
  }
}
