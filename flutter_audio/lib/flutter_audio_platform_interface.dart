import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_audio_method_channel.dart';

abstract class FlutterAudioPlatform extends PlatformInterface {
  /// Constructs a FlutterAudioPlatform.
  FlutterAudioPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterAudioPlatform _instance = MethodChannelFlutterAudio();

  /// The default instance of [FlutterAudioPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterAudio].
  static FlutterAudioPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterAudioPlatform] when
  /// they register themselves.
  static set instance(FlutterAudioPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
