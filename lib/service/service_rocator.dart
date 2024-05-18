import 'package:get_it/get_it.dart';
import 'package:mulink/service/audio/mulink_audio_handler.dart';

GetIt getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  getIt.registerSingleton<JustAudioHandler>(await initAudioService());
}
