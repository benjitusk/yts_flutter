import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:yts_flutter/classes/author.dart';
import 'package:yts_flutter/classes/streamable.dart';
import 'package:yts_flutter/classes/misc_types.dart';
import 'package:rxdart/rxdart.dart';
import 'package:yts_flutter/widgets/screens/Player/media_player.dart';

class AudioManager extends BaseAudioHandler {
  static final AudioManager _instance = AudioManager._internal();
  static AudioManager get instance => _instance;
  factory AudioManager() {
    return _instance;
  }

  // Streamable? currentContent;
  Stream<PlaybackSpeed> get playbackSpeedStream =>
      _player.speedStream.map((event) => PlaybackSpeed.fromValue(event));
  Stream<PlayerState> get playerStateStream =>
      _player.playerStateStream.asBroadcastStream();
  StreamController<Streamable?> _currentContentStream = BehaviorSubject();
  Stream<Streamable?> get currentContentStream => _currentContentStream.stream;
  Stream<PlaybackTimeData> get playTimeData =>
      Rx.combineLatest2<Duration, Duration, PlaybackTimeData>(
              _player.positionStream,
              _player.bufferedPositionStream,
              (pos, buffpos) => PlaybackTimeData(
                  pos, buffpos, _player.duration ?? Duration.zero))
          .asBroadcastStream();

  @override
  AudioManager._internal() {}

  // AudioHandler get _audioHandler => AudioPlayerHandler.audioHandler;
  final _player = AudioPlayer();

  @override
  Future<void> play() async {
    playbackState.add(playbackState.value.copyWith(
      playing: true,
      controls: [
        MediaControl.pause,
        MediaControl.fastForward,
        MediaControl.rewind,
      ],
    ));
    await _player.play();
  }

  @override
  Future<void> pause() {
    playbackState.add(playbackState.value.copyWith(
      playing: false,
      controls: [MediaControl.play],
    ));
    return _player.pause();
  }

  @override
  Future<void> stop() {
    playbackState.add(playbackState.value.copyWith(
      playing: false,
      processingState: AudioProcessingState.idle,
      controls: [MediaControl.play],
    ));
    // currentContent = null;
    return _player.stop();
  }

  Future<void> togglePlayPause() {
    if (playbackState.value.playing) {
      return pause();
    } else {
      return play();
    }
  }

  @override
  Future<void> setSpeed(double speed) async {
    return _player.setSpeed(speed);
  }

  Future<void> setSpeedByEnum(PlaybackSpeed speed) async {
    return setSpeed(speed.value);
  }

  @override
  Future<void> seek(Duration position) async {
    await _player.seek(position);
    playbackState.add(playbackState.value.copyWith(
      updatePosition: position,
      bufferedPosition: _player.bufferedPosition,
    ));
  }

  Future<void> relativeSeek(Duration offset) async {
    final position = await _player.position;
    return await seek(position + offset);
  }

  Future<void> loadContent(Streamable content) async {
    // if (content == currentContent) {
    //   return;
    // }
    // currentContent = content;
    // mediaIsInitailized = false;
    URL url = (content.cachedURL) ?? (await content.getStreamableURL()) as URL;
    mediaItem.add(MediaItem(
      id: content.id,
      title: content.title,
      album: content.title,
      artist: content.author.name,
      artUri: (content.author is Author)
          ? Uri.parse((content.author as Author).profilePictureURL)
          : null,
      duration: content.duration,
      // artUri: content.posterURL,
    ));
    await _player.setUrl(url);
    playbackState.add(playbackState.value.copyWith(
      controls: [MediaControl.pause],
      processingState: AudioProcessingState.ready,
      systemActions: const {
        MediaAction.seek,
        MediaAction.seekForward,
        MediaAction.seekBackward,
        MediaAction.setSpeed
      },
      playing: false,
      updatePosition: _player.position,
      bufferedPosition: _player.bufferedPosition,
    ));
    _currentContentStream.add(content);

    // currentContent = content;
    // await _player.setUrl(content.url);
    // mediaIsInitailized = true;
    // _contentStream.add(null);
  }

  void showMediaPlayer(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Column(
            mainAxisSize: MainAxisSize.min, children: [MediaPlayer()]);
      },
    );
  }
}

class PlaybackTimeData {
  final Duration position;
  final Duration bufferedPosition;
  final Duration duration;

  PlaybackTimeData(this.position, this.bufferedPosition, this.duration);
}

enum PlaybackSpeed {
  x0_5,
  x0_75,
  x1,
  x1_25,
  x1_5,
  x2,
  x2_5;

  double get value {
    switch (this) {
      case PlaybackSpeed.x0_5:
        return 0.5;
      case PlaybackSpeed.x0_75:
        return 0.75;
      case PlaybackSpeed.x1:
        return 1;
      case PlaybackSpeed.x1_25:
        return 1.25;
      case PlaybackSpeed.x1_5:
        return 1.5;
      case PlaybackSpeed.x2:
        return 2;
      case PlaybackSpeed.x2_5:
        return 2.5;
      default:
        return 1;
    }
  }

  static PlaybackSpeed fromValue(double value) {
    if (value == 0.5) {
      return PlaybackSpeed.x0_5;
    } else if (value == 0.75) {
      return PlaybackSpeed.x0_75;
    } else if (value == 1) {
      return PlaybackSpeed.x1;
    } else if (value == 1.25) {
      return PlaybackSpeed.x1_25;
    } else if (value == 1.5) {
      return PlaybackSpeed.x1_5;
    } else if (value == 2) {
      return PlaybackSpeed.x2;
    } else if (value == 2.5) {
      return PlaybackSpeed.x2_5;
    } else {
      return PlaybackSpeed.x1;
    }
  }
}
