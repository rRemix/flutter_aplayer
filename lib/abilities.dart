import 'dart:typed_data';

import 'package:flutter_audio/core.dart';

class Abilities {
  Abilities._();

  static Abilities get instance => _getInstance();
  static Abilities? _instance;

  static Abilities _getInstance() {
    _instance ??= Abilities._();
    return _instance!;
  }

  final _audioPlugin = FlutterAudio();

  Future<bool> checkPermissions() async {
    final bool? hasPermissions = await _audioPlugin.permissionsStatus();
    if (hasPermissions == true) {
      return true;
    }
    return await _audioPlugin.permissionsRequest() ?? false;
  }

  Future<List<Song>> querySongs() async {
    if (await checkPermissions()) {
      final songs = await _audioPlugin.querySongs(
          sortType: SortTypeSong.TITLE, orderType: OrderType.ASC);
      if (songs != null) {
        return songs;
      }
    }
    return [];
  }

  Future<List<Album>> queryAlbums() async {
    if (await checkPermissions()) {
      final albums = await _audioPlugin.queryAlbums(
          sortType: SortTypeAlbum.ALBUM, orderType: OrderType.ASC);
      if (albums != null) {
        return albums;
      }
    }
    return [];
  }

  Future<Uint8List?> queryArtwork(num id, ArtworkType type,
      {ArtworkFormat? format, int? size, int? quality}) async {
    return await _audioPlugin.queryArtwork(id, type,
        format: format, size: size, quality: quality);
  }

  Future<void> setLogEnable(bool enable) async {
    return await _audioPlugin.setLogEnable(enable);
  }
}
