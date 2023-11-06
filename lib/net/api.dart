import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_aplayer/model/netease/n_song.dart';
import 'package:flutter_aplayer/utils.dart';

import '../model/netease/n_lyric.dart';

final neteaseDio = Dio()
  ..options = BaseOptions(
      baseUrl: 'http://music.163.com/api/',
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5));

class Api {
  static Future<NSong?> searchtNeteaseSong(String key, int offset, int limit) {
    return neteaseDio
        .request('search/get',
            queryParameters: {
              's': key,
              'offset': offset,
              'limit': limit,
              'type': 1
            },
            options: Options(method: 'get', headers: {
              'User-Agent':
                  'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/60.0.3112.90 Safari/537.36'
            }))
        .then((response) {
      if (response.statusCode == 200) {
        final nSong = NSong.fromMap(json.decode(response.data));
        return nSong;
      }
      return Future.value(null);
    });
  }

  static Future<NLyric?> searchtNeteaseLyric(int id) {
    return neteaseDio.request('song/lyric', queryParameters: {
      'os': 'pc',
      'id': id,
      'lv': -1,
      'kv': -1,
      'tv': -1
    }).then((response) {
      if (response.statusCode == 200) {
        return NLyric.fromMap(json.decode(response.data));
      }
      return Future.value(null);
    });
  }

  static Future<String?> searchNeteaseArtUri(
      String title, String? artist, String album, bool searchAlbum) async {
    String key = Utils.getNeteaseSearchKey(title, album, artist, searchAlbum);

    return searchtNeteaseSong(key, 0, 1).then((nSong) => nSong?.result?.songs?.first.album?.picUrl);
  }
}
