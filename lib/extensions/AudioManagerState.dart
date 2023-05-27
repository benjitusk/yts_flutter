import 'package:audioplayers/audioplayers.dart';

enum AudioManagerState {
  BUFFERING,
  COMPLETED,
  PAUSED,
  PLAYING,
  STOPPED;
  static AudioManagerState fromPlayerState(PlayerState state) {
    switch (state) {
      case PlayerState.playing:
        return AudioManagerState.PLAYING;
      case PlayerState.paused:
        return AudioManagerState.PAUSED;
      case PlayerState.stopped:
        return AudioManagerState.STOPPED;
      case PlayerState.completed:
        return AudioManagerState.COMPLETED;
      default:
        return AudioManagerState.BUFFERING;
    }
  }


  // COMPLETED,
  // ERROR,
  // LOADING,
  // IDLE,
  // CONNECTING,
  // DISCONNECTED,
  // WAITING,
  // FAST_FORWARDING,
  // REWINDING,
  // SKIPPING_TO_PREVIOUS,
  // SKIPPING_TO_NEXT,
  // SEEKING_FORWARD,
  // SEEKING_BACKWARD,
  // CONNECTED,
  // SEEK_COMPLETED,
  // NONE,
}