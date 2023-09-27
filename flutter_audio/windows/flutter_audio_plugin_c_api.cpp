#include "include/flutter_audio/flutter_audio_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "flutter_audio_plugin.h"

void FlutterAudioPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  flutter_audio::FlutterAudioPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
