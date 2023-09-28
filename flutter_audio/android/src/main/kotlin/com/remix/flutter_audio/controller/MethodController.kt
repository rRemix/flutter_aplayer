package com.remix.flutter_audio.controller

import com.remix.flutter_audio.Method
import com.remix.flutter_audio.PluginProvider
import com.remix.flutter_audio.query.AudioQuery

class MethodController {

  fun find() {
    when(PluginProvider.call().method) {
      Method.QUERY_AUDIOS -> AudioQuery().querySongs()
    }
  }
}