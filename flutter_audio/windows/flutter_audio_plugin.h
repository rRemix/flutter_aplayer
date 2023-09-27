#ifndef FLUTTER_PLUGIN_FLUTTER_AUDIO_PLUGIN_H_
#define FLUTTER_PLUGIN_FLUTTER_AUDIO_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace flutter_audio {

class FlutterAudioPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  FlutterAudioPlugin();

  virtual ~FlutterAudioPlugin();

  // Disallow copy and assign.
  FlutterAudioPlugin(const FlutterAudioPlugin&) = delete;
  FlutterAudioPlugin& operator=(const FlutterAudioPlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace flutter_audio

#endif  // FLUTTER_PLUGIN_FLUTTER_AUDIO_PLUGIN_H_
