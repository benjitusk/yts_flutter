import 'package:audio_service/audio_service.dart';
import 'package:yts_flutter/Classes/Streamable.dart';
import 'package:yts_flutter/notifiers/play_button_notifier.dart';
import 'package:yts_flutter/notifiers/progress_notifier.dart';
import 'package:yts_flutter/notifiers/repeat_button_notifier.dart';
import '../services/service_locator.dart';
import 'package:flutter/material.dart';

class AudioManager {
  final AudioHandler _audioHandler = getIt<AudioHandler>();

  // Listeners: Updates going to the UI
  final currentSongTitleNotifier = ValueNotifier<String>("");
  final playlistNotifier = ValueNotifier<List<String>>([]);
  final progressNotifier = ProgressNotifier();
  final repeatButtonNotifier = RepeatButtonNotifier();
  final playButtonNotifier = PlayButtonNotifier();
  final isFirstSongNotifier = ValueNotifier<bool>(true);
  final isLastSongNotifier = ValueNotifier<bool>(true);
  final isShuffleModeNotifier = ValueNotifier<bool>(false);

  // Events: Updates coming from the UI
  void init() async {
    _listenToChangesInPlaylist();
    _listenToPlaybackState();
    _listenToChangesInSong();
    _listenToCurrentPosition();
    _listenToBufferedPosition();
    _listenToTotalDuration();
  }

  void play() {
    _audioHandler.play();
  }

  void pause() {
    _audioHandler.pause();
  }

  void seek(Duration position) {
    _audioHandler.seek(position);
  }

  void previous() {
    _audioHandler.skipToPrevious();
  }

  void next() {
    _audioHandler.skipToNext();
  }

  void repeat() {
    _audioHandler.setRepeatMode(AudioServiceRepeatMode.all);
  }

  void shuffle() {
    _audioHandler.setShuffleMode(AudioServiceShuffleMode.all);
  }

  void add(Streamable content) async {
    // final song = await songRepository.fetchAnotherSong();
    final mediaItem = MediaItem(
      id: content.id,
      album: content.date.toLocal().toString(),
      title: content.title,
      artist: content.author.name,
      extras: {'url': content.playbackUrl},
    );
    _audioHandler.addQueueItem(mediaItem);
  }

  void remove() {
    final lastIndex = _audioHandler.queue.value.length - 1;
    if (lastIndex < 0) return;
    _audioHandler.removeQueueItemAt(lastIndex);
  }

  void dispose() {
    _audioHandler.stop();
  }

  void _listenToPlaybackState() {
    _audioHandler.playbackState.listen((playbackState) {
      final isPlaying = playbackState.playing;
      final processingState = playbackState.processingState;
      if (processingState == AudioProcessingState.loading ||
          processingState == AudioProcessingState.buffering) {
        playButtonNotifier.value = ButtonState.loading;
      } else if (!isPlaying) {
        playButtonNotifier.value = ButtonState.paused;
      } else if (processingState != AudioProcessingState.completed) {
        playButtonNotifier.value = ButtonState.playing;
      } else {
        _audioHandler.seek(Duration.zero);
        _audioHandler.pause();
      }
    });
  }

  void _listenToChangesInSong() {
    _audioHandler.mediaItem.listen((mediaItem) {
      currentSongTitleNotifier.value = mediaItem?.title ?? '';
      _updateSkipButtons();
    });
  }

  void _updateSkipButtons() {
    final mediaItem = _audioHandler.mediaItem.value;
    final playlist = _audioHandler.queue.value;
    if (playlist.length < 2 || mediaItem == null) {
      isFirstSongNotifier.value = true;
      isLastSongNotifier.value = true;
    } else {
      isFirstSongNotifier.value = playlist.first == mediaItem;
      isLastSongNotifier.value = playlist.last == mediaItem;
    }
  }

  void _listenToChangesInPlaylist() {
    _audioHandler.queue.listen((playlist) {
      if (playlist.isEmpty) {
        playlistNotifier.value = [];
        currentSongTitleNotifier.value = '';
      } else {
        final newList = playlist.map((item) => item.title).toList();
        playlistNotifier.value = newList;
      }
      _updateSkipButtons();
    });
  }

  void _listenToCurrentPosition() {
    AudioService.position.listen((position) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: position,
        buffered: oldState.buffered,
        total: oldState.total,
      );
    });
  }

  void _listenToBufferedPosition() {
    _audioHandler.playbackState.listen((playbackState) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: oldState.current,
        buffered: playbackState.bufferedPosition,
        total: oldState.total,
      );
    });
  }

  void _listenToTotalDuration() {
    _audioHandler.mediaItem.listen((mediaItem) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: oldState.current,
        buffered: oldState.buffered,
        total: mediaItem?.duration ?? Duration.zero,
      );
    });
  }
}
