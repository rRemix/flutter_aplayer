import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_audio/type/artwork_type.dart';
import 'package:flutter_audio/type/order_type.dart';
import 'package:flutter_audio/type/sort_type/sort_type_album.dart';
import 'package:flutter_audio/type/sort_type/sort_type_song.dart';

import 'flutter_audio_platform_interface.dart';
import 'models/album.dart';
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
    final List<dynamic> result =
        await methodChannel.invokeMethod("querySongs", {
      "sortType": sortType?.index ?? SortTypeSong.TITLE,
      "orderType": orderType?.index ?? OrderType.ASC.index
    });
    return result.map((e) => Song.fromMap(e)).toList();
  }

  @override
  Future<List<Album>> queryAlbums(
      {SortTypeAlbum? sortType, OrderType? orderType}) async {
    final List<dynamic> result =
        await methodChannel.invokeMethod("queryAlbums", {
      "sortType": sortType?.index ?? SortTypeAlbum.ALBUM,
      "orderType": orderType?.index ?? OrderType.ASC
    });
    return result.map((e) => Album.fromMap(e)).toList();
  }

  @override
  Future<Uint8List?> queryArtwork(num id, ArtworkType type,
      {ArtworkFormat? format, int? size, int? quality}) async {
    return await methodChannel.invokeMethod("queryArtwork", {
      "id": id,
      "type": type.index,
      "format": format?.index ?? ArtworkFormat.JPEG.index,
      "size": size ?? 200,
      "quality": quality ?? 50
    });
  }
}
