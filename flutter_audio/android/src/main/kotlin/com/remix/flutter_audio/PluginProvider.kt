package com.remix.flutter_audio

import android.app.Activity
import android.content.Context
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.lang.ref.WeakReference

object PluginProvider {
  private const val ERROR_MESSAGE =
    "Tried to get one of the methods but the 'PluginProvider' has not initialized"

  private lateinit var context: WeakReference<Context>

  private lateinit var activity: WeakReference<Activity>

  private lateinit var call: WeakReference<MethodCall>

  private lateinit var result: WeakReference<MethodChannel.Result>

  fun set(activity: Activity) {
    context = WeakReference(activity.applicationContext)
    PluginProvider.activity = WeakReference(activity)
  }

  fun setCurrentMethod(call: MethodCall, result: MethodChannel.Result) {
    PluginProvider.call = WeakReference(call)
    PluginProvider.result = WeakReference(result)
  }

  fun context(): Context {
    return context.get() ?: throw IllegalStateException(ERROR_MESSAGE)
  }

  fun activity(): Context {
    return activity.get() ?: throw IllegalStateException(ERROR_MESSAGE)
  }

  fun call(): MethodCall {
    return call.get() ?: throw IllegalStateException(ERROR_MESSAGE)
  }

  fun result(): MethodChannel.Result {
    return result.get() ?: throw IllegalStateException(ERROR_MESSAGE)
  }
}