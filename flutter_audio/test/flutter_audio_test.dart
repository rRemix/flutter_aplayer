import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_audio/flutter_audio.dart';
import 'package:flutter_audio/flutter_audio_platform_interface.dart';
import 'package:flutter_audio/flutter_audio_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterAudioPlatform
    with MockPlatformInterfaceMixin
    implements FlutterAudioPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FlutterAudioPlatform initialPlatform = FlutterAudioPlatform.instance;

  test('$MethodChannelFlutterAudio is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterAudio>());
  });

  test('getPlatformVersion', () async {
    FlutterAudio flutterAudioPlugin = FlutterAudio();
    MockFlutterAudioPlatform fakePlatform = MockFlutterAudioPlatform();
    FlutterAudioPlatform.instance = fakePlatform;

    expect(await flutterAudioPlugin.getPlatformVersion(), '42');
  });
}
