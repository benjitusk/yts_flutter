import 'package:audio_service/audio_service.dart';
import 'package:get_it/get_it.dart';
import 'package:yts_flutter/classes/audio_manager.dart';
import 'audio_handler.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  // Register services
  // GetIt.I.registerLazySingleton(() => AudioHandler());
  getIt.registerSingleton<AudioHandler>(await initAudioService());
  getIt.registerSingleton<AudioManager>(AudioManager());
}
