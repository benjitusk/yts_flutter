import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:yts_flutter/Classes/Streamable.dart';
import 'package:yts_flutter/Classes/audio_manager.dart';
import 'package:yts_flutter/widgets/pages/media_player.dart';

class MediaController {
  static final MediaController instance = MediaController._();
  MediaController._();
  final _manager = GetIt.instance<AudioManager>();
  Streamable? currentlyPlaying = null;

  void play(Streamable content) {
    _manager.add(content);
    currentlyPlaying = content;
    _manager.play();
  }

  void showMediaPlayer(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx, builder: (BuildContext context) => MediaPlayer());
  }
}
