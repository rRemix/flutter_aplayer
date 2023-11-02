// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
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
  String get localeName => 'en';

  static String m0(title) => "Playing: ${title}";

  static String m1(time) => "APlayer will be closed in ${time} minutes";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "accent_color": MessageLookupByLibrary.simpleMessage("Accent color"),
        "accent_color_tip": MessageLookupByLibrary.simpleMessage(
            "Customize your favorite color for APlayer"),
        "add_to_playlist":
            MessageLookupByLibrary.simpleMessage("add to playlist"),
        "always_off": MessageLookupByLibrary.simpleMessage("Always off"),
        "always_on": MessageLookupByLibrary.simpleMessage("Always on"),
        "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
        "cancel_timer":
            MessageLookupByLibrary.simpleMessage("Cancel sleep timer"),
        "close": MessageLookupByLibrary.simpleMessage("关闭"),
        "color": MessageLookupByLibrary.simpleMessage("Color"),
        "confirm": MessageLookupByLibrary.simpleMessage("Confirm"),
        "dark_theme": MessageLookupByLibrary.simpleMessage("Dark theme"),
        "delete": MessageLookupByLibrary.simpleMessage("delete"),
        "exit": MessageLookupByLibrary.simpleMessage("Exit"),
        "follow_system": MessageLookupByLibrary.simpleMessage("Follow system"),
        "no_lrc": MessageLookupByLibrary.simpleMessage("No lyrics"),
        "play_history":
            MessageLookupByLibrary.simpleMessage("Playback History"),
        "playing_song": m0,
        "primary_color": MessageLookupByLibrary.simpleMessage("Primary color"),
        "primary_color_tip":
            MessageLookupByLibrary.simpleMessage("Main color for all page"),
        "searching": MessageLookupByLibrary.simpleMessage("Searching"),
        "setting": MessageLookupByLibrary.simpleMessage("Settings"),
        "song_library": MessageLookupByLibrary.simpleMessage("Library"),
        "start_timer":
            MessageLookupByLibrary.simpleMessage("Start sleep timer"),
        "support_developer":
            MessageLookupByLibrary.simpleMessage("Support Developer"),
        "tab_album": MessageLookupByLibrary.simpleMessage("Album"),
        "tab_artist": MessageLookupByLibrary.simpleMessage("Artist"),
        "tab_genre": MessageLookupByLibrary.simpleMessage("Genre"),
        "tab_playlist": MessageLookupByLibrary.simpleMessage("Playlist"),
        "tab_song": MessageLookupByLibrary.simpleMessage("Song"),
        "timer": MessageLookupByLibrary.simpleMessage("Fall Asleep to Music"),
        "will_stop_at_x": m1
      };
}
