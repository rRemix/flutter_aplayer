package com.remix.flutter_audio.utils

import io.flutter.BuildConfig
import io.flutter.Log

object LogUtil {
  private var enable = true
  private var logLevel = Log.VERBOSE

  var ASSERT = Log.ASSERT
  var DEBUG = Log.DEBUG
  var ERROR = Log.ERROR
  var INFO = Log.INFO
  var VERBOSE = Log.VERBOSE
  var WARN = Log.WARN

  fun setLogLevel(logLevel: Int) {
    this.logLevel = logLevel
  }

  fun setEnable(enable: Boolean) {
    this.enable = enable
  }

  fun println(level: Int, tag: String, message: String) {
    if (enable) {
      Log.println(level, tag, message)
    }
  }

  fun v(tag: String, message: String) {
    if (enable) {
      Log.v(tag, message)
    }
  }

  fun v(tag: String, message: String, tr: Throwable) {
    if (enable) {
      Log.v(tag, message, tr)
    }
  }

  fun i(tag: String, message: String) {
    if (enable) {
      Log.i(tag, message)
    }
  }

  fun i(tag: String, message: String, tr: Throwable) {
    if (enable) {
      Log.i(tag, message, tr)
    }
  }

  fun d(tag: String, message: String) {
    if (enable) {
      Log.d(tag, message)
    }
  }

  fun d(tag: String, message: String, tr: Throwable) {
    if (enable) {
      Log.d(tag, message, tr)
    }
  }

  fun w(tag: String, message: String) {
    if (enable && BuildConfig.DEBUG) {
      Log.w(tag, message)
    }
  }

  fun w(tag: String, message: String, tr: Throwable) {
    if (enable && BuildConfig.DEBUG) {
      Log.w(tag, message, tr)
    }
  }

  fun e(tag: String, message: String) {
    if (enable && BuildConfig.DEBUG) {
      Log.e(tag, message)
    }
  }

  fun e(tag: String, message: String, tr: Throwable) {
    if (enable && BuildConfig.DEBUG) {
      Log.e(tag, message, tr)
    }
  }

  fun wtf(tag: String, message: String) {
    if (enable && BuildConfig.DEBUG) {
      Log.wtf(tag, message)
    }
  }

  fun wtf(tag: String, message: String, tr: Throwable) {
    if (enable && BuildConfig.DEBUG) {
      Log.wtf(tag, message, tr)
    }
  }

  fun getStackTraceString(tr: Throwable?): String {
    if (enable && BuildConfig.DEBUG) {
      return  Log.getStackTraceString(tr)
    }
    return ""
  }
}