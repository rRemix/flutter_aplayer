package com.remix.flutter_audio

import com.remix.flutter_audio.controller.MethodController
import com.remix.flutter_audio.controller.PermissionController
import com.remix.flutter_audio.utils.LogUtil
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.lang.IllegalArgumentException

/** FlutterAudioPlugin */
class FlutterAudioPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
  private var binding: ActivityPluginBinding? = null
  private lateinit var channel: MethodChannel

  private val permissionController = PermissionController()
  private val methodController = MethodController()

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    LogUtil.d(TAG, "onAttachedToEngine")
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, CHANNEL_NAME)
    channel.setMethodCallHandler(this)
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    LogUtil.d(TAG, "onDetachedFromEngine")
    channel.setMethodCallHandler(null)
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    LogUtil.d(TAG, "onMethodCall, name: ${call.method}")

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

      Method.SET_LOG_CONFIG -> {
        LogUtil.setLogLevel(call.argument<Int>("config") ?: throw IllegalArgumentException("request 'config'"))
      }

      Method.SET_LOG_ENABLE -> {
        LogUtil.setEnable(call.argument<Boolean>("enable") ?: throw IllegalArgumentException("request 'enable'"))
      }

      else -> {
        // check permission
        val hasPermission = permissionController.permissionStatus()
        LogUtil.d(TAG, "check permissions: $hasPermission")
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
    LogUtil.d(TAG, "onAttachedToActivity")
    PluginProvider.set(binding.activity)
    this.binding = binding
    binding.addRequestPermissionsResultListener(permissionController)
  }

  override fun onDetachedFromActivity() {
    binding?.removeRequestPermissionsResultListener(permissionController)
    this.binding = null
    LogUtil.d(TAG, "onDetachedFromActivity")
  }

  override fun onDetachedFromActivityForConfigChanges() {
    LogUtil.d(TAG, "onDetachedFromActivityForConfigChanges")
    onDetachedFromActivity()
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    LogUtil.d(TAG, "onReattachedToActivityForConfigChanges")
    onAttachedToActivity(binding)
  }

  companion object {
    private const val TAG = "FlutterAudioPlugin"
    private const val CHANNEL_NAME = "com.remix.flutter_audio"
  }
}
