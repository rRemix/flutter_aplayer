import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_audio/sort/order_type.dart';
import 'package:flutter_audio/sort/sort_type_song.dart';

import 'flutter_audio_platform_interface.dart';
import 'models/song.dart';

/// An implementation of [FlutterAudioPlatform] that uses method channels.
class MethodChannelFlutterAudio extends FlutterAudioPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('com.remix.flutter_audio');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<bool?> permissionsStatus() async {
    return await methodChannel.invokeMethod<bool>("permissionsStatus");
  }

  @override
  Future<bool?> permissionsRequest() async {
    return await methodChannel.invokeMethod<bool>("permissionsRequest");
  }

  @override
  Future<List<Song>?> querySongs(
      {SortTypeSong? sortType, OrderType? orderType}) async {
    final List<dynamic> result = await methodChannel.invokeMethod("querySongs",
        {"sortType": sortType?.index, "orderType": orderType?.index});
    return result.map((e) => Song.fromMap(e)).toList();
  }
}
