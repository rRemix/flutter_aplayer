package com.remix.flutter_audio.utils

import android.content.Context
import android.database.Cursor
import android.os.Build
import android.provider.MediaStore
import android.provider.MediaStore.Audio
import android.provider.MediaStore.Audio.AudioColumns
import androidx.annotation.WorkerThread
import com.remix.flutter_audio.PluginProvider
import com.remix.flutter_audio.model.Song
import com.remix.flutter_audio.model.Song.Companion.EMPTY_SONG
import io.flutter.Log
import java.util.*
import kotlin.collections.ArrayList
import kotlin.collections.HashSet

/**
 * Created by taeja on 16-2-17.
 */
/**
 * 数据库工具类
 */
object MediaStoreUtil {
  private const val TAG = "MediaStoreUtil"

  private val context: Context
    get() = PluginProvider.context()


  //扫描文件默认大小设置
  var SCAN_SIZE = 1024
  private val BASE_PROJECTION: Array<String> = run {
    val projection = ArrayList(
      listOf(
        AudioColumns._ID,
        AudioColumns.TITLE,
        AudioColumns.TITLE_KEY,
        AudioColumns.DISPLAY_NAME,
        AudioColumns.TRACK,
        AudioColumns.SIZE,
        AudioColumns.YEAR,
        AudioColumns.TRACK,
        AudioColumns.DURATION,
        AudioColumns.DATE_MODIFIED,
        AudioColumns.DATE_ADDED,
        AudioColumns.DATA,
        AudioColumns.ALBUM_ID,
        AudioColumns.ALBUM,
        AudioColumns.ARTIST_ID,
        AudioColumns.ARTIST
      )
    )
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
      projection.add(AudioColumns.GENRE)
    }
    projection.toTypedArray()
  }

//  @JvmStatic
//  fun getAllArtist(): List<Artist> {
//    if (!PermissionUtil.hasNecessaryPermission()) {
//      return ArrayList()
//    }
//    val artistMaps: MutableMap<Long, MutableList<Artist>> = LinkedHashMap()
//    val artists: MutableList<Artist> = ArrayList()
//    val sortOrder = SPUtil.getValue(
//        context,
//        SETTING_KEY.NAME,
//        SETTING_KEY.ARTIST_SORT_ORDER,
//        SortOrder.ARTIST_A_Z
//    )
//    try {
//      context.contentResolver
//          .query(Audio.Media.EXTERNAL_CONTENT_URI, arrayOf(Audio.Media.ARTIST_ID,
//              Audio.Media.ARTIST),
//              baseSelection,
//              baseSelectionArgs,
//              sortOrder).use { cursor ->
//            if (cursor != null) {
//              while (cursor.moveToNext()) {
//                try {
//                  val artistId = cursor.getLong(0)
//                  if (artistMaps[artistId] == null) {
//                    artistMaps[artistId] = ArrayList()
//                  }
//                  artistMaps[artistId]?.add(Artist(artistId, cursor.getString(1), 0))
//                } catch (ignored: Exception) {
//                }
//              }
//              for ((_, value) in artistMaps) {
//                try {
//                  val artist = value[0]
//                  artist.count = value.size
//                  artists.add(artist)
//                } catch (e: Exception) {
//                  Timber.v("addArtist failed: $e")
//                }
//              }
//            }
//          }
//    } catch (e: Exception) {
//      Timber.v("getAllArtist failed: $e")
//    }
//    return if (forceSort) {
//      ItemsSorter.sortedArtists(artists, sortOrder)
//    } else {
//      artists
//    }
//  }

//  @JvmStatic
//  fun getAllAlbum(): List<Album> {
//    if (!PermissionUtil.hasNecessaryPermission()) {
//      return ArrayList()
//    }
//    val albumMaps: MutableMap<Long, MutableList<Album>> = LinkedHashMap()
//    val albums: MutableList<Album> = ArrayList()
//    val sortOrder = SPUtil.getValue(
//        context,
//        SETTING_KEY.NAME,
//        SETTING_KEY.ALBUM_SORT_ORDER,
//        SortOrder.ALBUM_A_Z
//    )
//    try {
//      context.contentResolver
//          .query(Audio.Media.EXTERNAL_CONTENT_URI, arrayOf(Audio.Media.ALBUM_ID,
//              Audio.Media.ALBUM,
//              Audio.Media.ARTIST_ID,
//              Audio.Media.ARTIST),
//              baseSelection,
//              baseSelectionArgs,
//              sortOrder).use { cursor ->
//            if (cursor != null) {
//              while (cursor.moveToNext()) {
//                try {
//                  val albumId = cursor.getLong(0)
//                  if (albumMaps[albumId] == null) {
//                    albumMaps[albumId] = ArrayList()
//                  }
//                  albumMaps[albumId]?.add(Album(albumId,
//                      cursor.getString(1),
//                      cursor.getLong(2),
//                      cursor.getString(3),
//                      0))
//                } catch (ignored: Exception) {
//                }
//              }
//              for ((_, value) in albumMaps) {
//                try {
//                  val album = value[0]
//                  album.count = value.size
//                  albums.add(album)
//                } catch (e: Exception) {
//                  Timber.v("addAlbum failed: $e")
//                }
//              }
//            }
//          }
//    } catch (e: Exception) {
//      Timber.v("getAllAlbum failed: $e")
//    }
//    return if (forceSort) {
//      ItemsSorter.sortedAlbums(albums, sortOrder)
//    } else {
//      albums
//    }
//  }

  @JvmStatic
  fun getAllSong(): List<Song> {
    return getSongs(null,
        null,
        null)
  }

  @JvmStatic
  fun getLastAddedSong(): List<Song> {
    val today = Calendar.getInstance()
    today.time = Date()
    return getSongs(Audio.Media.DATE_ADDED + " >= ?", arrayOf((today.timeInMillis / 1000 - 3600 * 24 * 7).toString()),
        Audio.Media.DATE_ADDED)
  }

  /**
   * 获得所有歌曲id
   */
  val allSongsId: List<Long>
    get() = getSongIds(
        null,
        null,
        null)

//  @JvmStatic
//  fun getAllFolder(): List<Folder> {
//    if (!PermissionUtil.hasNecessaryPermission()) {
//      return Collections.emptyList()
//    }
//
//    val songs = getSongs(null, null)
//    val folders: MutableList<Folder> = ArrayList()
//    val folderMap: MutableMap<String, MutableList<Song>> = LinkedHashMap()
//    try {
//      for (song in songs) {
//        val parentPath = song.data.substring(0, song.data.lastIndexOf("/"))
//        if (folderMap[parentPath] == null) {
//          folderMap[parentPath] = ArrayList()
//        }
//        folderMap[parentPath]?.add(song)
//      }
//
//      for ((path, songs) in folderMap) {
//        folders.add(Folder(path.substring(path.lastIndexOf("/") + 1), songs.size, path))
//      }
//    } catch (e: Exception) {
//      Timber.v(e)
//    }
//    return folders
//  }

  /**
   * 根据歌手或者专辑id获取所有歌曲
   *
   * @param id 歌手id 专辑id
   * @param type 1:专辑  2:歌手
   * @return 对应所有歌曲的id
   */
//  @JvmStatic
//  fun getSongsByArtistIdOrAlbumId(id: Long, type: Int): List<Song> {
//    var selection: String? = null
//    var sortOrder: String? = null
//    var selectionValues: Array<String?>? = null
//    if (type == Constants.ALBUM) {
//      selection = Audio.Media.ALBUM_ID + "=?"
//      selectionValues = arrayOf(id.toString() + "")
//      sortOrder = SPUtil.getValue(
//        context, SETTING_KEY.NAME,
//          SETTING_KEY.CHILD_ALBUM_SONG_SORT_ORDER,
//          SortOrder.SONG_A_Z)
//    }
//    if (type == Constants.ARTIST) {
//      selection = Audio.Media.ARTIST_ID + "=?"
//      selectionValues = arrayOf(id.toString() + "")
//      sortOrder = SPUtil.getValue(
//        context, SETTING_KEY.NAME,
//          SETTING_KEY.CHILD_ARTIST_SONG_SORT_ORDER,
//          SortOrder.SONG_A_Z)
//    }
//    return getSongs(selection, selectionValues, sortOrder)
//  }

  /**
   * 根据记录集获得歌曲详细
   *
   * @param cursor 记录集
   * @return 拼装后的歌曲信息
   */
  @JvmStatic
  @WorkerThread
  fun getSongInfo(cursor: Cursor?): Song {
    if (cursor == null || cursor.columnCount <= 0) {
      return EMPTY_SONG
    }
    return Song(
      id = cursor.getLong(cursor.getColumnIndex(AudioColumns._ID)),
      displayName = Util.processInfo(
        cursor.getString(cursor.getColumnIndex(AudioColumns.DISPLAY_NAME)),
        Util.TYPE_DISPLAYNAME
      ),
      title = Util.processInfo(
        cursor.getString(cursor.getColumnIndex(AudioColumns.TITLE)),
        Util.TYPE_SONG
      ),
      album = Util.processInfo(
        cursor.getString(cursor.getColumnIndex(AudioColumns.ALBUM)),
        Util.TYPE_ALBUM
      ),
      albumId = cursor.getLong(cursor.getColumnIndex(AudioColumns.ALBUM_ID)),
      artist = Util.processInfo(
        cursor.getString(cursor.getColumnIndex(AudioColumns.ARTIST)),
        Util.TYPE_ARTIST
      ),
      artistId = cursor.getLong(cursor.getColumnIndex(AudioColumns.ARTIST_ID)),
      _duration = cursor.getLong(cursor.getColumnIndex(AudioColumns.DURATION)),
      data = cursor.getString(cursor.getColumnIndex(AudioColumns.DATA)),
      size = cursor.getLong(cursor.getColumnIndex(AudioColumns.SIZE)),
      year = cursor.getLong(cursor.getColumnIndex(AudioColumns.YEAR)).toString(),
      _genre = cursor.getColumnIndex(AudioColumns.GENRE).let {
        if (it != -1) {
          cursor.getString(it)
        } else {
          null
        }
      },
      track = cursor.getLong(cursor.getColumnIndex(AudioColumns.TRACK)).toString(),
      dateModified = cursor.getLong(cursor.getColumnIndex(AudioColumns.DATE_MODIFIED))
    )
  }

  fun getSongIdsByParentId(parentId: Long): List<Int> {
    val ids: MutableList<Int> = ArrayList()
    context.contentResolver
        .query(MediaStore.Files.getContentUri("external"), arrayOf("_id"), "parent = $parentId", null, null).use { cursor ->
          if (cursor != null) {
            while (cursor.moveToNext()) {
              ids.add(cursor.getInt(0))
            }
          }
        }
    return ids
  }

  /**
   * 根据专辑id查询歌曲详细信息
   *
   * @param albumId 歌曲id
   * @return 对应歌曲信息
   */
  fun getSongByAlbumId(albumId: Long): Song {
    return getSong(Audio.Media.ALBUM_ID + "=?", arrayOf(albumId.toString() + ""))
  }

  /**
   * 根据歌曲id查询歌曲详细信息
   *
   * @param id 歌曲id
   * @return 对应歌曲信息
   */
  @JvmStatic
  fun getSongById(id: Long): Song {
    return getSong(Audio.Media._ID + "=?", arrayOf(id.toString() + ""))
  }

  fun getSongsByIds(ids: List<Long>?): List<Song> {
    val songs: List<Song> = ArrayList()
    if (ids == null || ids.isEmpty()) {
      return songs
    }
    val selection = StringBuilder(127)
    selection.append(Audio.Media._ID + " in (")
    for (i in ids.indices) {
      selection.append(ids[i]).append(if (i == ids.size - 1) ") " else ",")
    }
    return getSongs(selection.toString(), null)
  }

  /**
   * 删除指定歌曲
   */
//  @WorkerThread
//  fun delete(activity: BaseActivity, songs: List<Song>?, deleteSource: Boolean): Int {
//    //保存是否删除源文件
//    SPUtil.putValue(App.context, SETTING_KEY.NAME, SETTING_KEY.DELETE_SOURCE,
//        deleteSource)
//    if (songs == null || songs.isEmpty()) {
//      return 0
//    }
//
//    //删除之前保存的所有移除歌曲id
//    val deleteId: MutableSet<String> = HashSet(
//        SPUtil.getStringSet(context, SETTING_KEY.NAME, SETTING_KEY.BLACKLIST_SONG))
//    //保存到sp
//    for (temp in songs) {
//      deleteId.add(temp.id.toString() + "")
//    }
//    SPUtil.putStringSet(
//      context, SETTING_KEY.NAME, SETTING_KEY.BLACKLIST_SONG,
//        deleteId)
//    //从播放队列和全部歌曲移除
//    deleteFromService(songs)
//    getInstance().deleteFromAllPlayList(songs).subscribe()
//
//    //删除源文件
//    if (deleteSource) {
//      deleteSource(activity, songs)
//    }
//
//    //刷新界面
//    context.contentResolver.notifyChange(Audio.Media.EXTERNAL_CONTENT_URI, null)
//    return songs.size
//  }

  /**
   * 删除单个源文件
   */
//  fun deleteSource(activity: BaseActivity, song: Song) {
//    try {
//      try {
//        context.contentResolver.delete(
//          song.contentUri,
//          "${AudioColumns._ID} = ?",
//          arrayOf(song.id.toString())
//        )
//      } catch (securityException: SecurityException) {
//        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q &&
//          securityException is RecoverableSecurityException
//        ) {
//          activity.startIntentSenderForResult(
//            securityException.userAction.actionIntent.intentSender,
//            REQUEST_DELETE_PERMISSION,
//            null,
//            0,
//            0,
//            0,
//            null
//          )
//          return
//        }
//        throw securityException
//      }
//    } catch (e: Exception) {
//      Timber.e("Fail to delete source")
//      e.printStackTrace()
//      ToastUtil.show(activity, R.string.delete_source_fail_tip, e)
//    }
//  }

  /**
   * 删除多个源文件
   */
//  private fun deleteSource(activity: BaseActivity, songs: List<Song>?) {
//    if (songs == null || songs.isEmpty()) {
//      return
//    }
//    val toDeleteSongs: ArrayList<Song> = ArrayList()
//    for (song in songs) {
//      if (Util.deleteFileSafely(File(song.data))) {
//        context.contentResolver.delete(
//          Audio.Media.EXTERNAL_CONTENT_URI,
//          "${AudioColumns._ID} = ?",
//          arrayOf(song.id.toString())
//        )
//      } else {
//        toDeleteSongs.add(song)
//      }
//    }
//    if (toDeleteSongs.isNotEmpty()) {
//      activity.toDeleteSongs = toDeleteSongs
//      deleteSource(activity, toDeleteSongs[0])
//    }
//  }

  /**
   * 过滤移出的歌曲以及铃声等
   */
  @JvmStatic
  val baseSelection: String
    get() {
      val deleteIds = HashSet<String>()
      val blacklist = HashSet<String>()
//      val deleteIds = SPUtil
//          .getStringSet(context, SETTING_KEY.NAME, SETTING_KEY.BLACKLIST_SONG)
//      val blacklist = SPUtil
//          .getStringSet(context, SETTING_KEY.NAME, SETTING_KEY.BLACKLIST)
      val baseSelection = " _data != '' AND " + Audio.Media.SIZE + " > " + SCAN_SIZE
      if (deleteIds.isEmpty() && blacklist.isEmpty()) {
        return baseSelection
      }
      val builder = StringBuilder(baseSelection)
      var i = 0
      if (deleteIds.isNotEmpty()) {
        builder.append(" AND ")
        for (id in deleteIds) {
          if (i == 0) {
            builder.append(Audio.Media._ID).append(" not in (")
          }
          builder.append(id)
          builder.append(if (i != deleteIds.size - 1) "," else ")")
          i++
        }
      }
      if (blacklist.isNotEmpty()) {
        builder.append(" AND ")
        i = 0
        for (path in blacklist) {
          builder.append(Audio.Media.DATA + " NOT LIKE ").append(" ? ")
          builder.append(if (i != blacklist.size - 1) " AND " else "")
          i++
        }
      }
      return builder.toString()
    }

  val baseSelectionArgs: Array<String?>
    get() {
      val blacklist = HashSet<String>()
//      val blacklist = SPUtil
//          .getStringSet(context, SETTING_KEY.NAME, SETTING_KEY.BLACKLIST)
      val selectionArgs = arrayOfNulls<String>(blacklist.size)
      val iterator: Iterator<String> = blacklist.iterator()
      var i = 0
      while (iterator.hasNext()) {
        selectionArgs[i] = iterator.next() + "%"
        i++
      }
      return selectionArgs
    }

  fun makeSongCursor(selection: String?, selectionValues: Array<String?>?,
                     sortOrder: String?): Cursor? {
    var selection = selection
    var selectionValues = selectionValues
    selection = if (selection != null && selection.trim { it <= ' ' } != "") {
      "$selection AND ($baseSelection)"
    } else {
      baseSelection
    }
    if (selectionValues == null) {
      selectionValues = arrayOfNulls(0)
    }
    val baseSelectionArgs = baseSelectionArgs
    val newSelectionValues = arrayOfNulls<String>(selectionValues.size + baseSelectionArgs.size)
    System.arraycopy(selectionValues, 0, newSelectionValues, 0, selectionValues.size)
    if (newSelectionValues.size - selectionValues.size >= 0) {
      System.arraycopy(baseSelectionArgs, 0,
          newSelectionValues, selectionValues.size,
          newSelectionValues.size - selectionValues.size)
    }

    return try {
      context.contentResolver.query(Audio.Media.EXTERNAL_CONTENT_URI,
          BASE_PROJECTION, selection, newSelectionValues, sortOrder)
    } catch (e: SecurityException) {
      null
    }
  }

  @JvmStatic
  fun getSongId(selection: String?, selectionValues: Array<String?>?): Long {
    val songs = getSongs(selection, selectionValues, null)
    return if (songs.isNotEmpty()) songs[0].id else -1
  }

  @JvmStatic
  fun getSongIds(selection: String?, selectionValues: Array<String?>?): List<Long> {
    return getSongIds(selection, selectionValues, null)
  }

  @JvmStatic
  fun getSongIds(selection: String?, selectionValues: Array<String?>?,
                 sortOrder: String?): List<Long> {
    if (!PermissionUtil.hasNecessaryPermission()) {
      return ArrayList()
    }
    val ids: MutableList<Long> = ArrayList()
    try {
      makeSongCursor(selection, selectionValues, sortOrder).use { cursor ->
        if (cursor != null && cursor.count > 0) {
          while (cursor.moveToNext()) {
            ids.add(cursor.getLong(cursor.getColumnIndex(Audio.Media._ID)))
          }
        }
      }
    } catch (ignore: Exception) {
    }
    return ids
  }

  @JvmStatic
  fun getSong(selection: String?, selectionValues: Array<String?>?): Song {
    val songs = getSongs(selection, selectionValues, null)
    return if (songs.isNotEmpty()) songs[0] else EMPTY_SONG
  }

  @JvmStatic
  fun getSongs(selection: String?, selectionValues: Array<String?>?,
               sortOrder: String?): List<Song> {
    if (!PermissionUtil.hasNecessaryPermission()) {
      return ArrayList()
    }
    val songs: MutableList<Song> = ArrayList()
    try {
      makeSongCursor(selection, selectionValues, sortOrder).use { cursor ->
        if (cursor != null && cursor.count > 0) {
          while (cursor.moveToNext()) {
            songs.add(getSongInfo(cursor))
          }
        }
      }
    } catch (e: Exception) {
      Log.v(TAG, e.toString())
    }
//    return if (forceSort) {
//      ItemsSorter.sortedSongs(songs, sortOrder)
//    } else {
//      songs
//    }
    return songs
  }

  @JvmStatic
  fun getSongs(selection: String?, selectionValues: Array<String?>?): List<Song> {
    return getSongs(selection, selectionValues, null)
  }

  /**
   * 歌曲数量
   */
  val count: Int
    get() {
      try {
        context.contentResolver
            .query(Audio.Media.EXTERNAL_CONTENT_URI, arrayOf(Audio.Media._ID), baseSelection,
                baseSelectionArgs,
                null).use { cursor ->
              if (cursor != null) {
                return cursor.count
              }
            }
      } catch (e: Exception) {
        Log.v(TAG, e.toString())
      }
      return 0
    }

  init {
//    SCAN_SIZE = SPUtil
//        .getValue(App.context, SETTING_KEY.NAME, SETTING_KEY.SCAN_SIZE, MB)
  }
}