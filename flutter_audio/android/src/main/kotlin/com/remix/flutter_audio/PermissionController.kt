package com.remix.flutter_audio

import io.flutter.plugin.common.PluginRegistry

class PermissionController : PluginRegistry.RequestPermissionsResultListener {

  override fun onRequestPermissionsResult(
    requestCode: Int,
    permissions: Array<out String>,
    grantResults: IntArray
  ): Boolean {
    return true
  }
}