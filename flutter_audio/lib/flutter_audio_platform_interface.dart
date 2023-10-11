import 'dart:typed_data';

import 'package:flutter_audio/core.dart';
import 'package:flutter_audio/type/artwork_type.dart';
import 'package:flutter_audio/type/log_type.dart';
import 'package:flutter_audio/type/order_type.dart';
import 'package:flutter_audio/type/sort_type/sort_type_song.dart';
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

  Future<List<Album>?> queryAlbums({SortTypeAlbum? sortType, OrderType? orderType}) {
    throw UnimplementedError('queryAlbums() has not been implemented.');
  }

  Future<Uint8List?> queryArtwork(num id, ArtworkType type, {ArtworkFormat? format, int? size, int? quality}){
    throw UnimplementedError('queryArtwork() has not been implemented.');
  }

  Future<void> setLogConfig(LogType type){
    throw UnimplementedError('setLogConfig() has not been implemented.');
  }

  Future<void> setLogEnable(bool enable){
    throw UnimplementedError('setLogEnable() has not been implemented.');
  }
}
