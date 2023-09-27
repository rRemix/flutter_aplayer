package com.remix.flutter_audio.model

import android.content.ContentUris
import android.media.MediaMetadataRetriever
import android.net.Uri
import android.provider.MediaStore

data class Song(
  val id: Long,
  val displayName: String,
  val title: String,
  val album: String,
  val albumId: Long,
  val artist: String,
  val artistId: Long,
  private var _duration: Long,
  val data: String,
  val size: Long,
  val year: String,
  private var _genre: String?,
  val track: String?,
  val dateModified: Long) : java.io.Serializable{
  
  val duration: Long
    get() {
      if (_duration <= 0 && id > 0 && data.isNotEmpty()) {
        val metadataRetriever = MediaMetadataRetriever()
        try {
          metadataRetriever.setDataSource(data)
          _duration =
            metadataRetriever.extractMetadata(MediaMetadataRetriever.METADATA_KEY_DURATION)!!
              .toLong()
        } catch (ignore: Exception) {
        } finally {
          metadataRetriever.release()
        }
      }
      return _duration
    }
  
  val genre: String
    get() {
      if (_genre.isNullOrEmpty() && id > 0 && data.isNotEmpty()) {
        val metadataRetriever = MediaMetadataRetriever()
        try {
          metadataRetriever.setDataSource(data)
          _genre = metadataRetriever.extractMetadata(MediaMetadataRetriever.METADATA_KEY_GENRE)!!
        } catch (ignore: Exception) {
        } finally {
          metadataRetriever.release()
        }
      }
      return _genre ?: ""
    }
  
  val contentUri: Uri
    get() = ContentUris.withAppendedId(MediaStore.Audio.Media.EXTERNAL_CONTENT_URI, id)
  
  val artUri: Uri
    get() = ContentUris.withAppendedId(Uri.parse("content://media/external/audio/albumart/"), albumId)

  fun toMap(): Map<String, Any?> {
    val map = HashMap<String, Any?>()
    map["id"] = id
    map["displayName"] = displayName
    map["title"] = title
    map["album"] = album
    map["albumId"] = albumId
    map["artist"] = artist
    map["artistId"] = artistId
    map["duration"] = _duration
    map["data"] = data
    map["size"] = size
    map["year"] = year
    map["genre"] = _genre
    map["track"] = track
    map["dateModified"] = dateModified

    return map
  }

  companion object {
    @JvmStatic
    val EMPTY_SONG = Song(-1, "", "", "", -1, "", -1, -1, "", -1, "", "", "", -1)
  }
}
