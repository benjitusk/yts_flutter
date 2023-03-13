import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:yts_flutter/Classes/Streamable.dart';

class MediaPlayer {
  MediaPlayer._() {}
  static final instance = MediaPlayer._();
  static shared() => instance;
  final player = AssetsAudioPlayer();

  void play(Streamable content) async {
    await player.open(
      Audio.network(content.playbackUrl),
      autoStart: true,
      showNotification: true,
      playInBackground: PlayInBackground.enabled,
    );
    player.play();
  }
}
