package com.remix.flutter_audio.controller

import android.Manifest
import android.content.pm.PackageManager
import android.os.Build
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import com.remix.flutter_audio.PluginProvider
import io.flutter.Log
import io.flutter.plugin.common.PluginRegistry

class PermissionController : PluginRegistry.RequestPermissionsResultListener {
  var retryRequest: Boolean = false

  private val permissions =
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
      arrayOf(Manifest.permission.READ_MEDIA_AUDIO, Manifest.permission.READ_MEDIA_IMAGES)
    } else {
      arrayOf(
        Manifest.permission.READ_EXTERNAL_STORAGE, Manifest.permission.WRITE_EXTERNAL_STORAGE)
    }

  override fun onRequestPermissionsResult(
    requestCode: Int,
    permissions: Array<out String>,
    grantResults: IntArray
  ): Boolean {
    if (requestCode != REQUEST_CODE) {
      return false
    }

    val granted = (grantResults.isNotEmpty() && grantResults[0] == PackageManager.PERMISSION_GRANTED)
    Log.d(TAG,"granted: $granted")

    val result = PluginProvider.result()
    when{
      granted -> result.success(true)
      retryRequest -> retryRequestPermission()
      else -> result.success(false)
    }

    return true
  }

  fun permissionStatus(): Boolean {
    return permissions.all {
      ContextCompat.checkSelfPermission(
        PluginProvider.context(),
        it
      ) == PackageManager.PERMISSION_GRANTED
    }
  }

  fun requestPermission() {
    Log.d(TAG, "requestPermission")
    ActivityCompat.requestPermissions(PluginProvider.activity(), permissions, REQUEST_CODE)
  }

  private fun retryRequestPermission() {
    val activity = PluginProvider.activity()
    if (ActivityCompat.shouldShowRequestPermissionRationale(activity, permissions[0])
      || ActivityCompat.shouldShowRequestPermissionRationale(activity, permissions[1])
    ) {
      Log.d(TAG, "retryRequestPermission permission request")
      retryRequest = false
      requestPermission()
    }
  }

  companion object {
    private const val TAG = "PermissionController"
    private const val REQUEST_CODE = 999
  }
}