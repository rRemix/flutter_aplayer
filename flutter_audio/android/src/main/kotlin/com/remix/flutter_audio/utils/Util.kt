package com.remix.flutter_audio.utils

object Util {
  /**
   * 处理歌曲名、歌手名或者专辑名
   *
   * @param origin 原始数据
   * @param type 处理类型 0:歌曲名 1:歌手名 2:专辑名 3:文件名
   * @return
   */
  const val TYPE_SONG = 0
  const val TYPE_ARTIST = 1
  const val TYPE_ALBUM = 2
  const val TYPE_DISPLAYNAME = 3
  fun processInfo(origin: String?, type: Int): String {
    return if (type == TYPE_SONG) {
      if (origin == null || origin == "") {
        "未知歌曲"
      } else {
//                return origin.lastIndexOf(".") > 0 ? origin.substring(0, origin.lastIndexOf(".")) : origin;
        origin
      }
    } else if (type == TYPE_DISPLAYNAME) {
      if (origin == null || origin == "") {
        "未知歌曲"
      } else {
        if (origin.lastIndexOf(".") > 0) origin.substring(0, origin.lastIndexOf(".")) else origin
      }
    } else {
      if (origin == null || origin == "") {
        if (type == TYPE_ARTIST) "未知艺术家" else "未知专辑"
      } else {
        origin
      }
    }
  }
}