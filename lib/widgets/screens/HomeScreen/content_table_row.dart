import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:yts_flutter/classes/audio_manager.dart';
import 'package:yts_flutter/classes/author.dart';
import 'package:yts_flutter/classes/favorites_manager.dart';
import 'package:yts_flutter/classes/streamable.dart';
import 'package:yts_flutter/extensions/Duration.dart';

class ContentTableRow extends StatelessWidget {
  const ContentTableRow(
      {super.key,
      required this.shiur,
      this.showAuthor = true,
      this.showFav = true});
  final _imageSize = 50.0;
  final bool showAuthor;
  final bool showFav;
  final Streamable shiur;

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: showAuthor
            ? (shiur.author is Author)
                ? CachedNetworkImage(
                    imageUrl: (shiur.author as Author).profilePictureURL,
                    imageBuilder: (context, imageProvider) => Container(
                      width: _imageSize,
                      height: _imageSize,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  )
                : const Icon(Icons.mic)
            : null,
        title: Text(shiur.title),
        subtitle: Text(
          DateFormat.yMMMd().format(shiur.date),
        ),
        // isThreeLine: true,

        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(shiur.duration.toHoursMinutesSeconds(),
                style: Theme.of(context).textTheme.bodySmall),
            if (showFav)
              StreamBuilder(
                  stream: FavoritesManager().favoritesStream,
                  builder: (context, _) {
                    final isFavorite = FavoritesManager().isFavorite(shiur.id);

                    if (isFavorite)
                      return Icon(Icons.bookmark_added,
                          color: Theme.of(context).colorScheme.tertiary);
                    return SizedBox();
                  }),
          ],
        ),
        onTap: () async {
          AudioManager().showMediaPlayer(context);
          await AudioManager().loadContent(shiur);
          await AudioManager().play();
        });
  }
}
