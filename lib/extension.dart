import 'package:audio_service/audio_service.dart';
import 'package:flutter_audio/core.dart';

const emptyMediaItem = MediaItem(id: "-1", title: "");

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