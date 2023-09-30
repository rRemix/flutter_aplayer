package com.remix.flutter_audio.model

import android.content.ContentUris
import android.net.Uri

data class Album(
  val albumId: Long,
  val album: String,
  val artist: String,
  var count: Int = 0
) {
  val artUri: Uri
    get() = ContentUris.withAppendedId(
      Uri.parse("content://media/external/audio/albumart/"),
      albumId
    )

  fun toMap(): Map<String, Any?> {
    val map = HashMap<String, Any?>()
    map["albumId"] = albumId
    map["album"] = album
    map["artist"] = artist
    map["count"] = count

    return map
  }
}
