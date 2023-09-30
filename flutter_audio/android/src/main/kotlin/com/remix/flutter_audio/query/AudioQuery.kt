package com.remix.flutter_audio.query

import android.provider.MediaStore
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.remix.flutter_audio.PluginProvider
import com.remix.flutter_audio.utils.MediaStoreUtil
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext

class AudioQuery : ViewModel() {

  fun querySongs() {
    val call = PluginProvider.call()
    val result = PluginProvider.result()

    val sortOrder = parseSortOrder(call.argument<Int>("sortType")!!, call.argument<Int>("orderType")!!)

    viewModelScope.launch {
      val songs = withContext(Dispatchers.IO) {
        MediaStoreUtil.getSongs(null, null, sortOrder).map { it.toMap() }
      }

      result.success(songs)
    }
  }

  private fun parseSortOrder(sort: Int, order: Int): String {
    val builder = StringBuilder(when(sort) {
      0 -> MediaStore.Audio.Media.TITLE
      1 -> MediaStore.Audio.Media.DISPLAY_NAME
      2 -> MediaStore.Audio.Media.ARTIST
      3 -> MediaStore.Audio.Media.ALBUM
      4 -> MediaStore.Audio.Media.DATE_MODIFIED
      5 -> MediaStore.Audio.Media.TRACK
      else -> MediaStore.Audio.Media.DEFAULT_SORT_ORDER
    })

    when(order) {
      1 -> builder.append(" DESC")
      else -> builder.append(" ASC")
    }

    return builder.toString()
  }
}