
import 'flutter_audio_platform_interface.dart';

class FlutterAudio {
  Future<String?> getPlatformVersion() {
    return FlutterAudioPlatform.instance.getPlatformVersion();
  }
}
