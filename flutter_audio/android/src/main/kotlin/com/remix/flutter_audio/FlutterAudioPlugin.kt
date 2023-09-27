package com.remix.flutter_audio

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
    if (call.method == "getPlatformVersion") {
      result.success("Android ${android.os.Build.VERSION.RELEASE}")
    } else {
      result.notImplemented()
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
