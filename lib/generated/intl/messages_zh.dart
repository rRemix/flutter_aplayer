// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a zh locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'zh';

  static String m0(title) => "正在播放: ${title}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "add_to_playlist": MessageLookupByLibrary.simpleMessage("添加到播放列表"),
        "delete": MessageLookupByLibrary.simpleMessage("删除"),
        "exit": MessageLookupByLibrary.simpleMessage("退出"),
        "play_history": MessageLookupByLibrary.simpleMessage("播放历史"),
        "playing_song": m0,
        "setting": MessageLookupByLibrary.simpleMessage("设置"),
        "song_library": MessageLookupByLibrary.simpleMessage("歌曲库"),
        "support_developer": MessageLookupByLibrary.simpleMessage("支持开发者"),
        "tab_album": MessageLookupByLibrary.simpleMessage("专辑"),
        "tab_artist": MessageLookupByLibrary.simpleMessage("艺术家"),
        "tab_genre": MessageLookupByLibrary.simpleMessage("流派"),
        "tab_playlist": MessageLookupByLibrary.simpleMessage("播放列表"),
        "tab_song": MessageLookupByLibrary.simpleMessage("歌曲")
      };
}
