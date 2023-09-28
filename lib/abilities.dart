
import 'package:flutter_audio/core.dart';
import 'package:flutter_audio/flutter_audio.dart';

class Abilities{
  final audioPlugin = FlutterAudio();

  Future<bool> checkPermissions() async {
    final bool? hasPermissions = await audioPlugin.permissionsStatus();
    if (hasPermissions == true) {
      return true;
    }
    return await audioPlugin.permissionsRequest() ?? false;
  }

  Future<List<Song>> loadSongs() async {
    if (await checkPermissions()) {
      final songs = await audioPlugin.querySongs(
          sortType: SortTypeSong.TITLE, orderType: OrderType.ASC);
      if (songs != null) {
        return songs;
      }
    }
    return [];
  }
}