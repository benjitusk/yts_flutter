import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:yts_flutter/classes/misc_types.dart';
import 'package:yts_flutter/classes/streamable.dart';
import 'package:yts_flutter/extensions/AudioManagerState.dart';
import '../widgets/pages/media_player.dart';
import 'package:flutter/material.dart';

class AudioManager {
  static final AudioManager _instance = AudioManager._internal();
  final AudioPlayer _player = AudioPlayer();
  final StreamController<void> _contentStream = StreamController.broadcast();
  final StreamController<AudioManagerState> _stateStream =
      StreamController.broadcast();
  Stream<void> get contentStream => _contentStream.stream;
  Stream<AudioManagerState> get stateStream => _stateStream.stream;
  AudioManagerState state = AudioManagerState.BUFFERING;
  bool mediaIsInitailized = false;
  // AudioManagerState get _state => state;
  set _state(AudioManagerState state) {
    this.state = state;
    _stateStream.add(state);
  }

  Streamable? currentContent;
  factory AudioManager() {
    return _instance;
  }

  AudioManager._internal() {
    // _player.onPlayerStateChanged.listen((PlayerState state) {
    //   print('Internal state changed from ${this.state} to $state.');
    //   this._state = AudioManagerState.fromPlayerState(state);
    // });
  }

  void resume() {
    _player.resume();
    _state = AudioManagerState.PLAYING;
  }

  void pause() {
    _player.pause();
    _state = AudioManagerState.PAUSED;
  }

  Future<void> seek(Duration position) async {
    final previousState = state;
    _state = AudioManagerState.BUFFERING;
    await _player.seek(position);
    _state = previousState;
  }

  void relativeSeek(Duration offset) async {
    final position = await _player.getCurrentPosition();
    if (position != null) {
      await seek(position + offset);
    }
  }

  void stop() {
    _player.stop();
    // currentContent = null;
    // _contentStream.add(null); // Notify listeners of change
    _state = AudioManagerState.STOPPED;
  }

  void play(Streamable content) async {
    if (currentContent?.id == content.id) {
      if (this.state != AudioManagerState.PLAYING) {
        _player.resume();
        _state = AudioManagerState.PLAYING;
      }
      return;
    }
    mediaIsInitailized = false;
    // _player.
    currentContent = content;
    _contentStream.add(null); // Notify listeners of change
    _state = AudioManagerState.BUFFERING;
    URL contentURL =
        (content.cachedURL) ?? (await content.getStreamableURL()) as URL;
    try {
      await _player.play(UrlSource(contentURL));
    } catch (e) {
      print('Error playing $contentURL');
      print(e);
      currentContent = null;
      return;
    }
    mediaIsInitailized = true;
    _state = AudioManagerState.PLAYING;
    print('Playing ${content.title}');
  }

  void showMediaPlayer(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Column(mainAxisSize: MainAxisSize.min, children: [
          MediaPlayer(
            player: _player,
            initialContent: currentContent!,
          )
        ]);
      },
    );
  }
}
