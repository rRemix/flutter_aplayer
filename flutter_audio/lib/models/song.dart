

class Song{
  final num id;
  final String displayName;
  final String title;
  final String album;
  final num albumId;
  final String artist;
  final num artistId;
  final num duration;
  final String data;
  final num size;
  final String year;
  final String? genre;
  final String? track;
  final num dateModified;

//<editor-fold desc="Data Methods">
  const Song({
    required this.id,
    required this.displayName,
    required this.title,
    required this.album,
    required this.albumId,
    required this.artist,
    required this.artistId,
    required this.duration,
    required this.data,
    required this.size,
    required this.year,
    this.genre,
    this.track,
    required this.dateModified,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Song &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          displayName == other.displayName &&
          title == other.title &&
          album == other.album &&
          albumId == other.albumId &&
          artist == other.artist &&
          artistId == other.artistId &&
          duration == other.duration &&
          data == other.data &&
          size == other.size &&
          year == other.year &&
          genre == other.genre &&
          track == other.track &&
          dateModified == other.dateModified);

  @override
  int get hashCode =>
      id.hashCode ^
      displayName.hashCode ^
      title.hashCode ^
      album.hashCode ^
      albumId.hashCode ^
      artist.hashCode ^
      artistId.hashCode ^
      duration.hashCode ^
      data.hashCode ^
      size.hashCode ^
      year.hashCode ^
      genre.hashCode ^
      track.hashCode ^
      dateModified.hashCode;

  @override
  String toString() {
    return 'Song{' +
        ' id: $id,' +
        ' displayName: $displayName,' +
        ' title: $title,' +
        ' album: $album,' +
        ' albumId: $albumId,' +
        ' artist: $artist,' +
        ' artistId: $artistId,' +
        ' duration: $duration,' +
        ' data: $data,' +
        ' size: $size,' +
        ' year: $year,' +
        ' genre: $genre,' +
        ' track: $track,' +
        ' dateModified: $dateModified,' +
        '}';
  }

  Song copyWith({
    num? id,
    String? displayName,
    String? title,
    String? album,
    num? albumId,
    String? artist,
    num? artistId,
    num? duration,
    String? data,
    num? size,
    String? year,
    String? genre,
    String? track,
    num? dateModified,
  }) {
    return Song(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      title: title ?? this.title,
      album: album ?? this.album,
      albumId: albumId ?? this.albumId,
      artist: artist ?? this.artist,
      artistId: artistId ?? this.artistId,
      duration: duration ?? this.duration,
      data: data ?? this.data,
      size: size ?? this.size,
      year: year ?? this.year,
      genre: genre ?? this.genre,
      track: track ?? this.track,
      dateModified: dateModified ?? this.dateModified,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'displayName': displayName,
      'title': title,
      'album': album,
      'albumId': albumId,
      'artist': artist,
      'artistId': artistId,
      'duration': duration,
      'data': data,
      'size': size,
      'year': year,
      'genre': genre,
      'track': track,
      'dateModified': dateModified,
    };
  }

  factory Song.fromMap(Map<dynamic, dynamic> map) {
    return Song(
      id: map['id'] as num,
      displayName: map['displayName'] as String,
      title: map['title'] as String,
      album: map['album'] as String,
      albumId: map['albumId'] as num,
      artist: map['artist'] as String,
      artistId: map['artistId'] as num,
      duration: map['duration'] as num,
      data: map['data'] as String,
      size: map['size'] as num,
      year: map['year'] as String,
      genre: map['genre'] as String?,
      track: map['track'] as String?,
      dateModified: map['dateModified'] as num,
    );
  }

//</editor-fold>
}