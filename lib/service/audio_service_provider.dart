import 'package:audio_service/audio_service.dart';

import 'audio_handler_impl.dart';

class AudioHandlerHelper {
  AudioHandlerHelper._internal();

  static final AudioHandlerHelper _instance = AudioHandlerHelper._internal();

  factory AudioHandlerHelper() {
    return _instance;
  }

  static AudioHandlerImpl? _audioHandler;
  static bool _initial = false;

  static Future<void> _initialize() async {
    _audioHandler = await AudioService.init(
        builder: () => AudioHandlerImpl(),
        config: const AudioServiceConfig(
          androidNotificationChannelId:
              'com.remix.flutter_aplayer.playing_notification',
          androidNotificationChannelName: 'now playing notification',
          androidNotificationOngoing: true,
        ));
  }

  Future<AudioHandlerImpl> getAudioHandler() async {
    if (!_initial) {
      await _initialize();
      _initial = true;
    }
    audioHandler = _audioHandler!;
    return _audioHandler!;
  }
}
