import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:yts_flutter/classes/streamable.dart';
import '../widgets/pages/media_player.dart';
import 'package:flutter/material.dart';

class AudioManager {
  static final AudioManager _instance = AudioManager._internal();
  final AudioPlayer _player = AudioPlayer();
  final StreamController<void> _contentStream = StreamController.broadcast();
  Stream<void> get contentStream => _contentStream.stream;
  Streamable? currentContent;

  factory AudioManager() {
    return _instance;
  }

  AudioManager._internal();

  void resume() => _player.resume();
  void pause() => _player.pause();
  void seek(Duration position) => _player.seek(position);
  void relativeSeek(Duration offset) async {
    final position = await _player.getCurrentPosition();
    if (position != null) {
      seek(position + offset);
    }
  }

  void stop() {
    _player.stop();
    currentContent = null;
  }

  void play(Streamable content) {
    if (currentContent?.id == content.id) {
      if (_player.state == PlayerState.playing) {
        pause();
      } else {
        resume();
      }
      return;
    }
    currentContent = content;
    () async {
      final url = await content.getStreamableURL();
      if (url == null) {
        print('No URL found');
        currentContent = null;
        return;
      }
      _player.play(UrlSource(url));
      _contentStream.add(null); // Notify listeners of change
      print('Playing ${content.title}');
    }();
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
