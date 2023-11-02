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

  static String m1(time) => "APlayer将在${time}分钟后关闭";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "accent_color": MessageLookupByLibrary.simpleMessage("强调色"),
        "accent_color_tip": MessageLookupByLibrary.simpleMessage("选择你喜欢的强调色"),
        "add_to_playlist": MessageLookupByLibrary.simpleMessage("添加到播放列表"),
        "always_off": MessageLookupByLibrary.simpleMessage("总是关闭"),
        "always_on": MessageLookupByLibrary.simpleMessage("总是开启"),
        "cancel": MessageLookupByLibrary.simpleMessage("取消"),
        "cancel_timer": MessageLookupByLibrary.simpleMessage("取消计时"),
        "close": MessageLookupByLibrary.simpleMessage("关闭"),
        "color": MessageLookupByLibrary.simpleMessage("色彩"),
        "confirm": MessageLookupByLibrary.simpleMessage("确认"),
        "dark_theme": MessageLookupByLibrary.simpleMessage("深色主题"),
        "delete": MessageLookupByLibrary.simpleMessage("删除"),
        "exit": MessageLookupByLibrary.simpleMessage("退出"),
        "follow_system": MessageLookupByLibrary.simpleMessage("跟随系统"),
        "no_lrc": MessageLookupByLibrary.simpleMessage("暂无歌词"),
        "play_history": MessageLookupByLibrary.simpleMessage("播放历史"),
        "playing_song": m0,
        "primary_color": MessageLookupByLibrary.simpleMessage("主色调"),
        "primary_color_tip": MessageLookupByLibrary.simpleMessage("所有页面主色调"),
        "searching": MessageLookupByLibrary.simpleMessage("搜索中"),
        "setting": MessageLookupByLibrary.simpleMessage("设置"),
        "song_library": MessageLookupByLibrary.simpleMessage("歌曲库"),
        "start_timer": MessageLookupByLibrary.simpleMessage("开始计时"),
        "support_developer": MessageLookupByLibrary.simpleMessage("支持开发者"),
        "tab_album": MessageLookupByLibrary.simpleMessage("专辑"),
        "tab_artist": MessageLookupByLibrary.simpleMessage("艺术家"),
        "tab_genre": MessageLookupByLibrary.simpleMessage("流派"),
        "tab_playlist": MessageLookupByLibrary.simpleMessage("播放列表"),
        "tab_song": MessageLookupByLibrary.simpleMessage("歌曲"),
        "timer": MessageLookupByLibrary.simpleMessage("伴着音乐入睡"),
        "will_stop_at_x": m1
      };
}
