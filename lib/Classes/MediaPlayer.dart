import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:yts_flutter/Classes/Streamable.dart';

const HASH = '039e62c8b146a76f19a2f42cc1e48161b0d097c21037aab51e448dfa41aa46fd';

class MediaPlayer {
  MediaPlayer._() {}
  static final instance = MediaPlayer._();
  static shared() => instance;
  final player = AssetsAudioPlayer.newPlayer();

  void play(Streamable content) async {
    final path = content.playbackUrl;
    try {
      await player.open(Audio.network(path),
          showNotification: true, notificationSettings: NotificationSettings());
      player.play();
    } catch (e) {
      print("Couldn't load media from ${path}");
    }
  }
}
