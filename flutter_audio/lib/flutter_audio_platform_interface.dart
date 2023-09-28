import 'package:flutter_audio/sort/order_type.dart';
import 'package:flutter_audio/sort/sort_type_song.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_audio_method_channel.dart';
import 'models/song.dart';

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

  Future<bool?> permissionsStatus() {
    throw UnimplementedError('permissionsStatus() has not been implemented.');
  }

  Future<bool?> permissionsRequest() {
    throw UnimplementedError('requestPermissions() has not been implemented.');
  }

  Future<List<Song>?> querySongs(
      {SortTypeSong? sortType, OrderType? orderType}) {
    throw UnimplementedError('getSongs() has not been implemented.');
  }
}
