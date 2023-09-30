
import 'package:flutter/cupertino.dart';

class Album{
  final num albumId;
  final String album;
  final String artist;
  final int count;

//<editor-fold desc="Data Methods">
  const Album({
    required this.albumId,
    required this.album,
    required this.artist,
    required this.count,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Album &&
          runtimeType == other.runtimeType &&
          albumId == other.albumId &&
          album == other.album &&
          artist == other.artist &&
          count == other.count);

  @override
  int get hashCode =>
      albumId.hashCode ^
      album.hashCode ^
      artist.hashCode ^
      count.hashCode;

  @override
  String toString() {
    return 'Album{' +
        ' albumId: $albumId,' +
        ' album: $album,' +
        ' artist: $artist,' +
        ' count: $count,' +
        '}';
  }

  Album copyWith({
    num? albumId,
    String? album,
    num? artistId,
    String? artist,
    int? count,
  }) {
    return Album(
      albumId: albumId ?? this.albumId,
      album: album ?? this.album,
      artist: artist ?? this.artist,
      count: count ?? this.count,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'albumId': albumId,
      'album': album,
      'artist': artist,
      'count': count,
    };
  }

  factory Album.fromMap(Map<dynamic, dynamic> map) {
    return Album(
      albumId: map['albumId'] as num,
      album: map['album'] as String,
      artist: map['artist'] as String,
      count: map['count'] as int,
    );
  }

//</editor-fold>
}