package com.remix.flutter_audio.model

import android.content.ContentUris
import android.net.Uri

data class Album(
  val albumID: Long,
  val album: String,
  val artistID: Long,
  val artist: String,
  var count: Int = 0
) {
  val artUri: Uri
    get() = ContentUris.withAppendedId(
      Uri.parse("content://media/external/audio/albumart/"),
      albumID
    )

  fun toMap(): Map<String, Any?> {
    val map = HashMap<String, Any?>()
    map["albumID"] = albumID
    map["album"] = album
    map["artistID"] = artistID
    map["artist"] = artist
    map["count"] = count

    return map
  }
}
