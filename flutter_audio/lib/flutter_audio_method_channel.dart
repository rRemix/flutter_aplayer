import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_audio_platform_interface.dart';

/// An implementation of [FlutterAudioPlatform] that uses method channels.
class MethodChannelFlutterAudio extends FlutterAudioPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('com.remix.flutter_audio');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
