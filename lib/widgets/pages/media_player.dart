import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:yts_flutter/classes/audio_manager.dart';
import 'package:yts_flutter/classes/author.dart';
import 'package:yts_flutter/classes/streamable.dart';
import 'dart:math' as math;

class MediaPlayer extends StatefulWidget {
  final AudioPlayer player;
  final AudioManager audioManager = AudioManager();
  final Streamable initialContent;
  MediaPlayer({
    super.key,
    required this.player,
    required this.initialContent,
  });

  @override
  State<MediaPlayer> createState() => _MediaPlayerState();
}

class _MediaPlayerState extends State<MediaPlayer> {
  PlayerState? _playerState;
  Duration? _duration;
  Duration? _position;
  Streamable? _currentContent;

  bool get _isPlaying => _playerState == PlayerState.playing;

  String get _durationText => _duration?.toString().split('.').first ?? '';
  String get _positionText => _position?.toString().split('.').first ?? '';

  AudioPlayer get _player => widget.player;

  @override
  void initState() {
    super.initState();
    // Use initial values from player
    _currentContent = widget.initialContent;
    _playerState = _player.state;
    _player.getDuration().then((value) {
      if (mounted) setState(() => _duration = value);
    });
    _player.getCurrentPosition().then((value) {
      if (mounted) setState(() => _position = value);
    });

    _initStreams();
  }

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
          Slider(
            onChanged: (v) {
              final duration = _duration;
              if (duration == null) {
                return;
              }
              final position = v * duration.inMilliseconds;
              _player.seek(Duration(milliseconds: position.round()));
            },
            value: (_position != null &&
                    _duration != null &&
                    _position!.inMilliseconds > 0 &&
                    _position!.inMilliseconds < _duration!.inMilliseconds)
                ? _position!.inMilliseconds / _duration!.inMilliseconds
                : 0.0,
          ),
          _buildTimeLabelRow(context),
          _buildMediaControls(context),
          _buildBottomButtons(context),
        ],
      ),
    );
  }

  Widget _buildContentMetadeta(BuildContext context) {
    return Row(children: [
      Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _currentContent?.title ?? 'null',
            maxLines: 2,
            softWrap: true,
            style: Theme.of(context).textTheme.titleLarge,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            _currentContent?.author.name ?? 'null',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
      Spacer(),
      (_currentContent?.author is Author)
          ? ClipOval(
              child: Image.network(
                (_currentContent?.author as Author).profilePictureURL,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
            )
          : Icon(Icons.person, size: 50),
    ]);
  }

  Widget _buildTimeLabelRow(BuildContext context) {
    return Row(
      children: [
        Text(
          _position != null ? '$_positionText' : '',
          style: const TextStyle(fontSize: 16.0),
        ),
        Spacer(),
        Text(
          _position != null ? '$_durationText' : '',
          style: const TextStyle(fontSize: 16.0),
        ),
      ],
    );
  }

  Widget _buildMediaControls(BuildContext context) {
    final IconData icon = _isPlaying ? Icons.pause : Icons.play_arrow;

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
        IconButton(
            onPressed: () {
              if (_isPlaying) {
                widget.audioManager.pause();
              } else {
                widget.audioManager.resume();
              }
            },
            icon: Icon(
              icon,
              size: 64.0,
            )),
        IconButton(
          onPressed: () =>
              widget.audioManager.relativeSeek(Duration(seconds: 15)),
          iconSize: 40.0,
          icon:const Icon(Icons.forward_10),
        ),
        Spacer()
      ],
    );
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

  void _initStreams() {
    widget.audioManager.contentStream.listen((_) {
      if (mounted)
        setState(() {
          _currentContent = widget.audioManager.currentContent;
        });
    });
    _player.onDurationChanged.listen((duration) {
      if (mounted) setState(() => _duration = duration);
    });
    _player.onPositionChanged.listen((position) {
      if (mounted) setState(() => _position = position);
    });
    _player.onPlayerComplete.listen((event) {
      if (mounted)
        setState(() {
          _playerState = PlayerState.stopped;
          _position = Duration.zero;
        });
    });
    _player.onPlayerStateChanged.listen((state) {
      if (mounted) setState(() => _playerState = state);
    });
  }
}
