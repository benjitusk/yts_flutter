import 'package:get_it/get_it.dart';
import 'package:yts_flutter/Classes/Streamable.dart';
import 'package:yts_flutter/Classes/audio_manager.dart';

class MediaController {
  static final MediaController instance = MediaController._();
  MediaController._();
  final _manager = GetIt.instance<AudioManager>();

  void play(Streamable content) {
    _manager.add(content);
    _manager.play();
  }
}
