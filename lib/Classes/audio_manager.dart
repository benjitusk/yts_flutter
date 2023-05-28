import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:yts_flutter/classes/author.dart';
import 'package:yts_flutter/classes/streamable.dart';
import 'package:yts_flutter/classes/misc_types.dart';
import 'package:rxdart/rxdart.dart';
import 'package:yts_flutter/main.dart';
import 'package:yts_flutter/widgets/pages/media_player.dart';

const MEDIA_URL =
    "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-7.mp3";

class AudioManager extends BaseAudioHandler {
  // static AudioHandler? audioHandler;
  // final _handler = audioHandler;
  static final AudioManager _instance = AudioManager._internal();
  static AudioManager get instance => _instance;
  factory AudioManager() {
    return _instance;
  }

  Streamable? currentContent;
  Stream<PlayerState> get playerStateStream => _player.playerStateStream;
  Stream<MediaState> get mediaStateStream =>
      Rx.combineLatest3<MediaItem?, Duration, Duration, MediaState>(
          audioHandler.mediaItem,
          _player.positionStream,
          _player.bufferedPositionStream,
          (mediaItem, position, buffpos) =>
              MediaState(mediaItem, position, buffpos));

  //final StreamController<void> _contentStream = StreamController.broadcast();
  //Stream<void> get contentStream => _contentStream.stream;

  @override
  AudioManager._internal() {
    // playbackState.add(playbackState.value.copyWith(
    //   controls: [
    //     MediaControl.skipToPrevious,
    //     MediaControl.pause,
    //     MediaControl.stop,
    //     MediaControl.play,
    //     MediaControl.skipToNext,
    //   ],
    //   androidCompactActionIndices: const [0, 1, 3, 4],
    //   processingState: AudioProcessingState.ready,
    //   playing: false,
    // ));
    // _player.setUrl(MEDIA_URL).then((value) {
    //   playbackState.add(playbackState.value.copyWith(
    //     processingState: AudioProcessingState.ready,
    //     playing: false,
    //   ));
    // });
  }

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
    currentContent = null;
    return _player.stop();
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
    if (content == currentContent) {
      return;
    }
    currentContent = content;
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
        return Column(mainAxisSize: MainAxisSize.min, children: [
          MediaPlayer(
            // player: _player,
            initialContent: currentContent!,
          )
        ]);
      },
    );
  }
}

class MediaState {
  final MediaItem? mediaItem;
  final Duration position;
  final Duration bufferedPosition;

  MediaState(this.mediaItem, this.position, this.bufferedPosition);
}
