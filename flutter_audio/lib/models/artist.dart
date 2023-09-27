
class Artist{
  final num artistId;
  final String artist;
  final int count;

//<editor-fold desc="Data Methods">
  const Artist({
    required this.artistId,
    required this.artist,
    required this.count,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Artist &&
          runtimeType == other.runtimeType &&
          artistId == other.artistId &&
          artist == other.artist &&
          count == other.count);

  @override
  int get hashCode => artistId.hashCode ^ artist.hashCode ^ count.hashCode;

  @override
  String toString() {
    return 'Artist{' +
        ' artistId: $artistId,' +
        ' artist: $artist,' +
        ' count: $count,' +
        '}';
  }

  Artist copyWith({
    num? artistId,
    String? artist,
    int? count,
  }) {
    return Artist(
      artistId: artistId ?? this.artistId,
      artist: artist ?? this.artist,
      count: count ?? this.count,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'artistId': artistId,
      'artist': artist,
      'count': count,
    };
  }

  factory Artist.fromMap(Map<String, dynamic> map) {
    return Artist(
      artistId: map['artistId'] as num,
      artist: map['artist'] as String,
      count: map['count'] as int,
    );
  }

//</editor-fold>
}