import 'package:audio_service/audio_service.dart';
import 'package:on_audio_query/on_audio_query.dart';

const emptyMediaItem = MediaItem(id: '-1', title: '');

extension SongExt on SongModel {
  MediaItem toMediaItem() {
    return MediaItem(
        id: id.toString(),
        title: title,
        album: album,
        artist: artist,
        genre: genre,
        duration: Duration(milliseconds: duration ?? 0),
        artUri: Uri.parse('content://media/external/audio/media/$id/albumart'),
        displayTitle: displayName);
  }
}

extension ListExt<T> on List<T> {
  T? getOrNull(int index) {
    if (index >= 0 && index < length) {
      return this[index];
    } else {
      return null;
    }
  }
}
