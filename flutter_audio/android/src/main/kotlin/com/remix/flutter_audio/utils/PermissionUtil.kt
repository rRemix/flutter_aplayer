package com.remix.flutter_audio.utils

import android.Manifest
import android.content.pm.PackageManager
import android.os.Build
import android.os.Environment
import androidx.annotation.RequiresApi
import androidx.core.content.ContextCompat
import com.remix.flutter_audio.PluginProvider

object PermissionUtil {
  val NECESSARY_PERMISSIONS =
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
      arrayOf(Manifest.permission.READ_MEDIA_AUDIO, Manifest.permission.READ_MEDIA_IMAGES)
    }  else {
      arrayOf(Manifest.permission.READ_EXTERNAL_STORAGE)
    }

  private fun has(vararg permissions: String): Boolean {
    return permissions.all {
      ContextCompat.checkSelfPermission(
        PluginProvider.context(),
        it
      ) == PackageManager.PERMISSION_GRANTED
    }
  }

  fun hasNecessaryPermission(): Boolean {
    return has(*NECESSARY_PERMISSIONS)
  }

  @RequiresApi(Build.VERSION_CODES.R)
  fun hasManageExternalStorage(): Boolean {
    return Environment.isExternalStorageManager()
  }

//  @RequiresApi(Build.VERSION_CODES.R)
//  fun requestManageExternalStorage(context: Context) {
//    context.startActivity(
//      Intent(Settings.ACTION_MANAGE_APP_ALL_FILES_ACCESS_PERMISSION).setData(
//        Uri.fromParts("package", BuildConfig.APPLICATION_ID, null)
//      )
//    )
//    // TODO: show toast when "a matching Activity not exists"
//  }


}