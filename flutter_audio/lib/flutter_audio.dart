import 'package:flutter_audio/sort/order_type.dart';
import 'package:flutter_audio/sort/sort_type_song.dart';

import 'flutter_audio_platform_interface.dart';
import 'models/song.dart';

class FlutterAudio {
  Future<String?> getPlatformVersion() {
    return FlutterAudioPlatform.instance.getPlatformVersion();
  }

  Future<bool?> permissionsStatus() {
    return FlutterAudioPlatform.instance.permissionsStatus();
  }

  Future<bool?> permissionsRequest() {
    return FlutterAudioPlatform.instance.permissionsRequest();
  }

  Future<List<Song>?> querySongs(
      {SortTypeSong? sortType, OrderType? orderType}) {
    return FlutterAudioPlatform.instance.querySongs(
        sortType: sortType, orderType: orderType);
  }
}
