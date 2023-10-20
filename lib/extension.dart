import 'package:audio_service/audio_service.dart';
import 'package:flutter_audio/core.dart';

const emptyMediaItem = MediaItem(id: "-1", title: "");
const emptySong = Song(id: -1, displayName: "", title: "", album: "", albumId: -1, artist: "", artistId: -1, duration: 0, data: "", size: 0, year: "", dateModified: 0);
extension SongExt on Song {
  MediaItem toMediaItem() {
    return MediaItem(id: id.toString(),
        title: title,
        album: album,
        artist: artist,
        genre: genre,
        duration: Duration(milliseconds: duration.toInt()),
        artUri: Uri.parse(artUri),
        displayTitle: displayName);
  }
}