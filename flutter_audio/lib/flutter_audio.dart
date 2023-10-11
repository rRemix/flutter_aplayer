import 'dart:typed_data';

import 'package:flutter_audio/core.dart';

import 'flutter_audio_platform_interface.dart';

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
    return FlutterAudioPlatform.instance
        .querySongs(sortType: sortType, orderType: orderType);
  }

  Future<List<Album>?> queryAlbums(
      {SortTypeAlbum? sortType, OrderType? orderType}) {
    return FlutterAudioPlatform.instance
        .queryAlbums(sortType: sortType, orderType: orderType);
  }

  Future<Uint8List?> queryArtwork(num id, ArtworkType type,
      {ArtworkFormat? format, int? size, int? quality}) async {
    return FlutterAudioPlatform.instance
        .queryArtwork(id, type, format: format, size: size, quality: quality);
  }

  Future<void> setLogConfig(LogType type) async {
    return FlutterAudioPlatform.instance.setLogConfig(type);
  }

  Future<void> setLogEnable(bool enable) async {
    return FlutterAudioPlatform.instance.setLogEnable(enable);
  }
}
