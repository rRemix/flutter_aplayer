package com.remix.flutter_audio.model

data class Artist(val artistID: Long,
                  val artist: String,
                  var count: Int) {
  fun toMap(): Map<String, Any?> {
    val map = HashMap<String, Any?>()
    map["artistID"] = artistID
    map["artist"] = artist
    map["count"] = count

    return map
  }
}
