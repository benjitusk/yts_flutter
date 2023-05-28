import 'dart:math';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:yts_flutter/classes/audio_manager.dart';
import 'package:yts_flutter/classes/streamable.dart';

class MediaPlayer extends StatefulWidget {
  // final AudioPlayer player;
  final AudioManager audioManager = AudioManager();
  final Streamable initialContent;
  MediaPlayer({
    super.key,
    // required this.player,
    required this.initialContent,
  });

  @override
  State<MediaPlayer> createState() => _MediaPlayerState();
}

class _MediaPlayerState extends State<MediaPlayer> {
  // AudioManagerState? _playerState;
  // Duration? _duration;
  // Duration? _position;
  // Streamable? _currentContent;
  // List<StreamSubscription> _subscriptions = [];

  // bool get _isPlaying => _playerState == AudioManagerState.PLAYING;

  // String get _durationText {
  //   if (widget.audioManager.mediaIsInitailized == false) {
  //     return "--:--";
  //   }
  //   return _duration?.toString().split('.').first ?? '';
  // }

  // String get _positionText {
  //   if (widget.audioManager.mediaIsInitailized == false) {
  //     return "--:--";
  //   }
  //   return _position?.toString().split('.').first ?? '';
  // }

  // AudioPlayer get _player => widget.player;

  @override
  void initState() {
    super.initState();
    print("MediaPlayer init state");
    // Use initial values from player
    // _currentContent = widget.initialContent;
    // _playerState = widget.audioManager.state;
    // widget.player.getDuration().then((value) {
    //   if (mounted) setState(() => _duration = value);
    // });
    // widget.player.getCurrentPosition().then((value) {
    //   if (mounted) setState(() => _position = value);
    // });

    // _initStreams();
  }

  // @override
  // void dispose() {
  //   _deinitStreams();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final themeSensitiveIcon = isDarkTheme
        ? const AssetImage('assets/Shraga_white.png')
        : const AssetImage('assets/Shraga_black.png');
    return Padding(
      padding: const EdgeInsets.all(24.00),
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Image(image: themeSensitiveIcon),
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
      stream: AudioManager.instance.mediaStateStream,
      builder: (context, mediaState) => Row(children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              mediaState.data?.mediaItem?.title ?? '--',
              maxLines: 2,
              softWrap: true,
              style: Theme.of(context).textTheme.titleLarge,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              mediaState.data?.mediaItem?.artist ?? '--',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
        Spacer(),
        (mediaState.data?.mediaItem?.artUri != null)
            ? ClipOval(
                child: Image.network(
                  mediaState.data!.mediaItem!.artUri!.toString(),
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
        stream: AudioManager.instance.mediaStateStream,
        builder: (context, snapshot) {
          final mediaState = snapshot.data;
          final duration = mediaState?.mediaItem?.duration ?? Duration.zero;
          final position = mediaState?.position ?? Duration.zero;
          final bufferedPosition =
              mediaState?.bufferedPosition.inMilliseconds ?? 0;
          return Slider(
            onChanged: (v) {
              final position = v * duration.inMilliseconds;
              widget.audioManager
                  .seek(Duration(milliseconds: position.round()));
            },
            value: (position.inMilliseconds > 0 &&
                    position.inMilliseconds < duration.inMilliseconds
                // Audio state is not completed
                // mediaState?. != AudioProcessingState.completed
                )
                ? position.inMilliseconds / duration.inMilliseconds
                : 0.0,
            secondaryTrackValue: (position.inMilliseconds > 0 &&
                    duration.inMilliseconds > 0 &&
                    bufferedPosition < duration.inMilliseconds &&
                    bufferedPosition > 0)
                ? bufferedPosition / duration.inMilliseconds
                : 0.0,
          );
        });
  }

  Widget _buildTimeLabelRow(BuildContext context) {
    return StreamBuilder(
      stream: AudioManager.instance.mediaStateStream,
      builder: (context, snapshot) {
        final mediaState = snapshot.data;
        final duration = mediaState?.mediaItem?.duration ?? Duration.zero;
        final position = mediaState?.position ?? Duration.zero;
        return Row(
          children: [
            Text(
              position.toString().split('.').first,
              style: const TextStyle(fontSize: 16.0),
            ),
            Spacer(),
            Text(
              duration.toString().split('.').first,
              style: const TextStyle(fontSize: 16.0),
            ),
          ],
        );
      },
    );
    // return Row(
    //   children: [
    //     Text(
    //       _position != null ? '$_positionText' : '',
    //       style: const TextStyle(fontSize: 16.0),
    //     ),
    //     Spacer(),
    //     Text(
    //       _position != null ? '$_durationText' : '',
    //       style: const TextStyle(fontSize: 16.0),
    //     ),
    //   ],
    // );
  }

  Widget _buildMediaControls(BuildContext context) {
    return Row(
      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Spacer(),
        IconButton(
          onPressed: () =>
              widget.audioManager.relativeSeek(Duration(seconds: -15)),
          iconSize: 40.0,
          icon: const Icon(Icons.replay_10),
        ),
        _buildMediaCenterButton(context),
        IconButton(
          onPressed: () =>
              widget.audioManager.relativeSeek(Duration(seconds: 15)),
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
            onPressed: widget.audioManager.play,
          );
        } else if (processingState != ProcessingState.completed) {
          return IconButton(
            icon: Icon(Icons.pause),
            iconSize: 64.0,
            onPressed: widget.audioManager.pause,
          );
        } else {
          return IconButton(
            icon: Icon(Icons.replay),
            iconSize: 64.0,
            onPressed: () => widget.audioManager.seek(Duration.zero),
          );
        }
      },
    );
    // IconData? icon = null;
    // switch (_playerState) {
    //   case AudioManagerState.PLAYING:
    //   case AudioManagerState.STOPPED:
    //     icon = Icons.pause;
    //     break;
    //   case AudioManagerState.PAUSED:
    //     icon = Icons.play_arrow;
    //     break;
    //   case AudioManagerState.COMPLETED:
    //     icon = Icons.replay;
    //     break;

    //   // case AudioManagerState.BUFFERING:
    //   default:
    //   //   icon = Icons.sync;
    //   //   break;
    // }

    // return Row(
    //   // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //   children: [
    //     Spacer(),
    //     IconButton(
    //       onPressed: () =>
    //           widget.audioManager.relativeSeek(Duration(seconds: -15)),
    //       iconSize: 40.0,
    //       icon: const Icon(Icons.replay_10),
    //     ),
    //     (icon == null)
    //         ? Container(
    //             margin: const EdgeInsets.all(20.0),
    //             width: 40.0,
    //             height: 40.0,
    //             child: const CircularProgressIndicator(),
    //           )
    //         : IconButton(
    //             onPressed: () {
    //               if (_isPlaying) {
    //                 widget.audioManager.pause();
    //               } else {
    //                 widget.audioManager.resume();
    //               }
    //             },
    //             icon: Icon(
    //               icon,
    //               size: 64.0,
    //             )),
    //     IconButton(
    //       onPressed: () =>
    //           widget.audioManager.relativeSeek(Duration(seconds: 15)),
    //       iconSize: 40.0,
    //       icon: const Icon(Icons.forward_10),
    //     ),
    //     Spacer()
    //   ],
    // );
  }

  Widget _buildBottomButtons(BuildContext context) {
    List<Map<IconData, VoidCallback>> buttons = [
      {
        Icons.favorite: () => null,
      },
      {
        Icons.speed: () => null,
      },
      {
        Icons.share: () => null,
      },
    ];
    return Row(
      children: [
        Spacer(),
        ...buttons.map((button) {
          final icon = button.keys.first;
          final onPressed = button.values.first;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                // backgroundColor: Theme.of(context).primaryColor,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16.0)),
                ),
                padding: const EdgeInsets.all(16.0),
              ),
              onPressed: onPressed,
              child: Icon(icon),
            ),
          );
        }),
        Spacer(),
      ],
    );
  }

  // void _initStreams() {
  //   _subscriptions.addAll([
  //     widget.audioManager.contentStream.listen((_) {
  //       if (mounted)
  //         setState(() {
  //           _currentContent = widget.audioManager.currentContent;
  //         });
  //     }),
  //     widget.audioManager.stateStream.listen((state) {
  //       print('State changed to $state');
  //       if (mounted) setState(() => _playerState = state);
  //     }),
  //     widget.player.onDurationChanged.listen((duration) {
  //       if (mounted) setState(() => _duration = duration);
  //     }),
  //     widget.player.onPositionChanged.listen((position) {
  //       if (mounted) setState(() => _position = position);
  //     }),
  //     widget.player.onPlayerComplete.listen((event) {
  //       if (mounted)
  //         setState(() {
  //           widget.audioManager.pause();
  //           widget.audioManager.seek(Duration.zero);
  //         });
  //     }),
  //   ]);
  // }

  // void _deinitStreams() {
  //   _subscriptions.forEach((s) => s.cancel());
  //   // _player.onPlayerComplete.drain();
  // }
}
