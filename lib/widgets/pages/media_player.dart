import 'dart:math';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:yts_flutter/classes/audio_manager.dart';
import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:yts_flutter/classes/favorites_manager.dart';
import 'package:yts_flutter/utils.dart';

class MediaPlayer extends StatelessWidget {
  final AudioManager audioManager = AudioManager();
  MediaPlayer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.00),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ShragaLogo(dark: isDarkTheme(context), animated: true),
          _buildContentMetadeta(context),
          _buildPositionSlider(context),
          _buildTimeLabelRow(context),
          _buildMediaControls(context),
          _buildBottomButtons(context),
        ],
      ),
    );
  }

  Widget _buildContentMetadeta(BuildContext context) {
    return StreamBuilder(
      stream: AudioManager.instance.mediaItem,
      builder: (context, mediaState) => Row(children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                height: /* must be responsive to text height*/
                    Theme.of(context).textTheme.titleLarge!.height! * 20,
                width: MediaQuery.of(context).size.width * 0.7,
                child: AutoMarqueeText(
                  mediaState.data?.title ?? '--',
                  style: Theme.of(context).textTheme.titleLarge,
                )),
            Text(
              mediaState.data?.artist ?? '--',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
        Spacer(),
        (mediaState.data?.artUri != null)
            ? ClipOval(
                child: Image.network(
                  mediaState.data!.artUri!.toString(),
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              )
            : Icon(Icons.person, size: 50),
      ]),
    );
  }

  Widget _buildPositionSlider(BuildContext context) {
    return StreamBuilder(
        stream: AudioManager.instance.playTimeData,
        builder: (context, snapshot) {
          final mediaState = snapshot.data;
          final duration = mediaState?.duration ?? Duration.zero;
          final position = mediaState?.position ?? Duration.zero;
          final bufferedPosition =
              mediaState?.bufferedPosition.inMilliseconds ?? 0;
          double bufferedPositionPercent =
              bufferedPosition / duration.inMilliseconds;
          bufferedPositionPercent = max(0.0, min(1.0, bufferedPositionPercent));
          if (bufferedPositionPercent.isNaN) bufferedPositionPercent = 0.0;
          return Slider(
            onChanged: (v) {
              final position = v * duration.inMilliseconds;
              audioManager.seek(Duration(milliseconds: position.round()));
            },
            value: (position.inMilliseconds > 0 &&
                    position.inMilliseconds < duration.inMilliseconds)
                ? position.inMilliseconds / duration.inMilliseconds
                : 0.0,
            secondaryTrackValue: bufferedPositionPercent,
          );
        });
  }

  Widget _buildTimeLabelRow(BuildContext context) {
    return Row(
      children: [
        StreamBuilder(
          stream: AudioManager.instance.playTimeData,
          builder: (context, snapshot) => Text(
            (snapshot.data?.position ?? Duration.zero)
                .toString()
                .split('.')
                .first,
            style: const TextStyle(fontSize: 16.0),
          ),
        ),
        Spacer(),
        StreamBuilder(
          stream: AudioManager.instance.mediaItem,
          builder: (context, snapshot) => Text(
            (snapshot.data?.duration ?? Duration.zero)
                .toString()
                .split('.')
                .first,
            style: const TextStyle(fontSize: 16.0),
          ),
        ),
      ],
    );
    // },
    // );
  }

  Widget _buildMediaControls(BuildContext context) {
    return Row(
      children: [
        Spacer(),
        IconButton(
          onPressed: () => audioManager.relativeSeek(Duration(seconds: -15)),
          iconSize: 40.0,
          icon: const Icon(Icons.replay_10),
        ),
        _buildMediaCenterButton(context),
        IconButton(
          onPressed: () => audioManager.relativeSeek(Duration(seconds: 15)),
          iconSize: 40.0,
          icon: const Icon(Icons.forward_10),
        ),
        Spacer()
      ],
    );
  }

  Widget _buildMediaCenterButton(BuildContext context) {
    return StreamBuilder(
      stream: AudioManager.instance.playerStateStream,
      builder: (context, snapshot) {
        final playerState = snapshot.data;
        final processingState = playerState?.processingState;
        final playing = playerState?.playing;
        if (processingState == ProcessingState.loading ||
            processingState == ProcessingState.buffering) {
          return Container(
            margin: const EdgeInsets.all(20.0),
            width: 40.0,
            height: 40.0,
            child: const CircularProgressIndicator(),
          );
        } else if (playing != true) {
          return IconButton(
            icon: Icon(Icons.play_arrow),
            iconSize: 64.0,
            onPressed: audioManager.play,
          );
        } else if (processingState != ProcessingState.completed) {
          return IconButton(
            icon: Icon(Icons.pause),
            iconSize: 64.0,
            onPressed: audioManager.pause,
          );
        } else {
          return IconButton(
            icon: Icon(Icons.play_arrow),
            iconSize: 64.0,
            onPressed: () => audioManager.seek(Duration.zero),
          );
        }
      },
    );
  }

  Widget _buildBottomButtons(BuildContext context) {
    return Row(
      children: [
        Spacer(),
        StreamBuilder(
            stream: AudioManager.instance.currentContentStream,
            builder: (context, snapshot) {
              final currentContent = snapshot.data;
              // FavoritesManager().isFavorite(currentContent);
              return StreamBuilder(
                  stream: FavoritesManager().favoritesStream,
                  builder: (context, _) {
                    final isFavorite =
                        FavoritesManager().isFavorite(currentContent?.id);
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16.0)),
                            ),
                            padding: const EdgeInsets.all(16.0),
                            foregroundColor:
                                Theme.of(context).colorScheme.tertiary),
                        onPressed: currentContent == null
                            ? null
                            : () {
                                if (isFavorite) {
                                  FavoritesManager().remove(currentContent.id);
                                } else {
                                  FavoritesManager().add(currentContent.id);
                                }
                              },
                        child: Icon(isFavorite
                            ? Icons.bookmark_added
                            : Icons.bookmark_add_outlined),
                      ),
                    );
                  });
            }),
        StreamBuilder(
            stream: audioManager.playbackSpeedStream,
            builder: (context, snapshot) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16.0)),
                      ),
                      padding: const EdgeInsets.all(16.0),
                    ),
                    onPressed: () => showAdaptiveActionSheet(
                        context: context,
                        actions: PlaybackSpeed.values
                            .map(
                              (speed) => BottomSheetAction(
                                title: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 4.0, horizontal: 12.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        'x' + speed.value.toString(),
                                        style: TextStyle(
                                            fontWeight: (snapshot.data == speed)
                                                ? FontWeight.bold
                                                : FontWeight.normal),
                                      ),
                                      Spacer(),
                                      if (snapshot.data == speed)
                                        Icon(
                                          Icons.check,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                    ],
                                  ),
                                ),
                                onPressed: (_) {
                                  audioManager.setSpeedByEnum(speed);
                                  Navigator.pop(context);
                                },
                              ),
                            )
                            .toList()),
                    child: Text(
                      'x' + (snapshot.data?.value.toString() ?? '1.0'),
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
              );
            }),
        ShareButton(),
        Spacer(),
      ],
    );
  }
}

class ShareButton extends StatefulWidget {
  const ShareButton({
    super.key,
  });
  @override
  State<ShareButton> createState() => _ShareButtonState();
}

class _ShareButtonState extends State<ShareButton> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: AudioManager().currentContentStream,
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16.0)),
                ),
                padding: const EdgeInsets.all(16.0),
              ),
              onPressed: null,
              child: isLoading
                  ? const CircularProgressIndicator()
                  : const Icon(Icons.share),
            ),
          );
        });
  }
}
