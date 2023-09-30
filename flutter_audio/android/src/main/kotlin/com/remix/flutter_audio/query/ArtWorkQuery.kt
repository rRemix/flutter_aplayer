package com.remix.flutter_audio.query

import android.content.ContentResolver
import android.content.ContentUris
import android.content.Context
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.media.MediaMetadataRetriever
import android.net.Uri
import android.os.Build
import android.provider.MediaStore
import android.util.Size
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.remix.flutter_audio.PluginProvider
import com.remix.flutter_audio.utils.MediaStoreUtil
import io.flutter.Log
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import java.io.ByteArrayOutputStream
import java.io.FileInputStream
import kotlin.math.min

class ArtWorkQuery : ViewModel() {
  private var type: Int = -1
  private var id: Long = 0
  private var quality: Int = 100
  private var size: Int = 200
  
  private lateinit var format: Bitmap.CompressFormat
  private lateinit var uri: Uri
  private lateinit var resolver: ContentResolver
  
  fun queryArtWork() {
    resolver = PluginProvider.context().contentResolver
    val call = PluginProvider.call()
    val result = PluginProvider.result()
    
    id = call.argument<Long>("id")!!
    type = call.argument<Int>("type")!!
    size = call.argument<Int>("size")!!
    quality = call.argument<Int>("quality")!!
    if (quality > 100) quality = 50
    
    val format = call.argument<Int>("format")!!
    this.format = if (format == 0) {
      Bitmap.CompressFormat.PNG
    } else {
      Bitmap.CompressFormat.JPEG
    }
    
    uri = if (type == 1) {
      MediaStore.Audio.Albums.EXTERNAL_CONTENT_URI
    } else {
      MediaStore.Audio.Media.EXTERNAL_CONTENT_URI
    }
    
    viewModelScope.launch {
      var bytes = loadArt()
      if (bytes != null && bytes.isEmpty()) {
        bytes = null
      }
      result.success(bytes)
    }
  }
  
  private suspend fun loadArt(): ByteArray? = withContext(Dispatchers.IO) {
    var artData: ByteArray? = null
    
    if (Build.VERSION.SDK_INT >= 29) {
      try {
        val query = if (type >= 2) {
          val item = MediaStoreUtil.loadFirstItem(type, id, resolver) ?: return@withContext null
          ContentUris.withAppendedId(uri, item.toLong())
        } else {
          ContentUris.withAppendedId(uri, id)
        }
        
        val bitmap = resolver.loadThumbnail(query, Size(size, size), null)
        artData = convertOrResize(bitmap)
      } catch (e: Exception) {
        Log.w(TAG, "loadArt, err: $e")
      }
    } else {
      val item = MediaStoreUtil.loadFirstItem(type, id, resolver) ?: return@withContext null
      try {
        val file = FileInputStream(item)
        val metaData = MediaMetadataRetriever().apply {
          setDataSource(file.fd)
        }
        
        artData = convertOrResize(byteArray = metaData.embeddedPicture) ?: return@withContext null
        
      } catch (e: Exception) {
        Log.w(TAG, "loadArt, err: $e")
      }
    }
    
    return@withContext artData
  }
  
  private fun convertOrResize(bitmap: Bitmap? = null, byteArray: ByteArray? = null): ByteArray? {
    val convertedBytes: ByteArray?
    val byteArrayBase = ByteArrayOutputStream()
    
    try {
      // If 'bitmap' isn't null:
      //   * The image(bitmap) is from first method. (Android >= 29/Q).
      // else:
      //   * The image(bytearray) is from second method. (Android < 29/Q).
      if (bitmap != null) {
        bitmap.compress(format, quality, byteArrayBase)
      } else {
        val convertedBitmap = BitmapFactory.decodeByteArray(byteArray, 0, byteArray!!.size)
        convertedBitmap.compress(format, quality, byteArrayBase)
      }
    } catch (e: Exception) {
      // This may produce a lot of logging on console so, will required a explicit request
      // to show the errors.
      Log.w(TAG, "($id) Message: $e")
    }
    
    convertedBytes = byteArrayBase.toByteArray()
    byteArrayBase.close()
    return convertedBytes
  }
  
  companion object {
    private const val TAG = "OnArtworksQuery"
  }
}