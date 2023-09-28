package com.remix.flutter_audio

import com.remix.flutter_audio.controller.MethodController
import com.remix.flutter_audio.controller.PermissionController
import io.flutter.Log
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** FlutterAudioPlugin */
class FlutterAudioPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
  private var binding: ActivityPluginBinding? = null
  private lateinit var channel: MethodChannel

  private val permissionController = PermissionController()
  private val methodController = MethodController()

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    Log.d(TAG, "onAttachedToEngine")
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, CHANNEL_NAME)
    channel.setMethodCallHandler(this)
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    Log.d(TAG, "onDetachedFromEngine")
    channel.setMethodCallHandler(null)
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    Log.d(TAG, "onMethodCall, name: ${call.method}")

    PluginProvider.setCurrentMethod(call, result)

    val retryRequest = call.argument<Boolean>("retryRequest") ?: false
    permissionController.retryRequest = retryRequest

    when (call.method) {
      Method.PERMISSION_STATUS -> {
        result.success(permissionController.permissionStatus())
      }

      Method.PERMISSION_REQUEST -> {
        permissionController.requestPermission()
      }

      else -> {
        // check permission
        val hasPermission = permissionController.permissionStatus()
        Log.d(TAG, "check permissions: $hasPermission")
        if (!hasPermission) {
          result.error(
            "MissingPermissions",
            "Application doesn't have access to the library",
            "Call the [permissionsRequest] method or install a external plugin to handle the app permission."
          )
          return
        }

        methodController.find()
      }
    }
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    Log.d(TAG, "onAttachedToActivity")
    PluginProvider.set(binding.activity)
    this.binding = binding
    binding.addRequestPermissionsResultListener(permissionController)
  }

  override fun onDetachedFromActivity() {
    binding?.removeRequestPermissionsResultListener(permissionController)
    this.binding = null
    Log.d(TAG, "onDetachedFromActivity")
  }

  override fun onDetachedFromActivityForConfigChanges() {
    Log.d(TAG, "onDetachedFromActivityForConfigChanges")
    onDetachedFromActivity()
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    Log.d(TAG, "onReattachedToActivityForConfigChanges")
    onAttachedToActivity(binding)
  }

  companion object {
    private const val TAG = "FlutterAudioPlugin"
    private const val CHANNEL_NAME = "com.remix.flutter_audio"
  }
}
