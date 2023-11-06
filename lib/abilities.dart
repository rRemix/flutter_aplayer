import 'dart:typed_data';

import 'package:on_audio_query/on_audio_query.dart';

class Abilities {
  Abilities._();

  static Abilities get instance => _getInstance();
  static Abilities? _instance;

  static Abilities _getInstance() {
    _instance ??= Abilities._();
    return _instance!;
  }

  final _audioQuery = OnAudioQuery();

  Future<bool> checkPermissions() async {
    final bool hasPermissions = await _audioQuery.permissionsStatus();
    if (hasPermissions) {
      return true;
    }
    return await _audioQuery.permissionsRequest();
  }

  Future<List<SongModel>> querySongs() async {
    if (await checkPermissions()) {
      final songs = await _audioQuery.querySongs(
          sortType: SongSortType.TITLE, orderType: OrderType.ASC_OR_SMALLER);
      return songs.where((element) => element.size > 500 * 1024).toList();
    }
    return [];
  }

  Future<List<AlbumModel>> queryAlbums() async {
    if (await checkPermissions()) {
      final albums = await _audioQuery.queryAlbums(
          sortType: AlbumSortType.ALBUM, orderType: OrderType.ASC_OR_SMALLER);
      return albums;
    }
    return [];
  }

  Future<Uint8List?> queryArtwork(int id, ArtworkType type,
      {ArtworkFormat? format, int? size, int? quality}) async {
    return await _audioQuery.queryArtwork(id, type,
        format: format, size: size, quality: quality);
  }

  Future<void> setLogEnable(LogConfig logConfig) async {
    return await _audioQuery.setLogConfig(logConfig);
  }
}
