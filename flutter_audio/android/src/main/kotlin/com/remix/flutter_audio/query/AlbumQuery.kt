package com.remix.flutter_audio.query

import android.provider.MediaStore
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.remix.flutter_audio.PluginProvider
import com.remix.flutter_audio.utils.MediaStoreUtil
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext

class AlbumQuery : ViewModel() {
  
  
  fun queryAlbums() {
    val call = PluginProvider.call()
    val result = PluginProvider.result()
    
    val sortOrder =
      parseSortOrder(call.argument<Int>("sortType")!!, call.argument<Int>("orderType")!!)
    
    viewModelScope.launch {
      val albums = withContext(Dispatchers.IO) {
        MediaStoreUtil.getAllAlbum(sortOrder).map { it.toMap() }
      }

      result.success(albums)
    }
  }
  
  private fun parseSortOrder(sort: Int, order: Int): String {
    val builder = StringBuilder(
      when (sort) {
        0 -> MediaStore.Audio.Albums.ALBUM
        1 -> MediaStore.Audio.Albums.ARTIST
        2 -> MediaStore.Audio.Albums.NUMBER_OF_SONGS
        else -> MediaStore.Audio.Albums.DEFAULT_SORT_ORDER
      }
    )
    
    when (order) {
      1 -> builder.append(" DESC")
      else -> builder.append(" ASC")
    }
    
    return builder.toString()
  }
}