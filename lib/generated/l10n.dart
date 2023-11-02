// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Confirm`
  String get confirm {
    return Intl.message(
      'Confirm',
      name: 'confirm',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `关闭`
  String get close {
    return Intl.message(
      '关闭',
      name: 'close',
      desc: '',
      args: [],
    );
  }

  /// `Song`
  String get tab_song {
    return Intl.message(
      'Song',
      name: 'tab_song',
      desc: '',
      args: [],
    );
  }

  /// `Album`
  String get tab_album {
    return Intl.message(
      'Album',
      name: 'tab_album',
      desc: '',
      args: [],
    );
  }

  /// `Artist`
  String get tab_artist {
    return Intl.message(
      'Artist',
      name: 'tab_artist',
      desc: '',
      args: [],
    );
  }

  /// `Genre`
  String get tab_genre {
    return Intl.message(
      'Genre',
      name: 'tab_genre',
      desc: '',
      args: [],
    );
  }

  /// `Playlist`
  String get tab_playlist {
    return Intl.message(
      'Playlist',
      name: 'tab_playlist',
      desc: '',
      args: [],
    );
  }

  /// `Library`
  String get song_library {
    return Intl.message(
      'Library',
      name: 'song_library',
      desc: '',
      args: [],
    );
  }

  /// `Playback History`
  String get play_history {
    return Intl.message(
      'Playback History',
      name: 'play_history',
      desc: '',
      args: [],
    );
  }

  /// `Support Developer`
  String get support_developer {
    return Intl.message(
      'Support Developer',
      name: 'support_developer',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get setting {
    return Intl.message(
      'Settings',
      name: 'setting',
      desc: '',
      args: [],
    );
  }

  /// `Exit`
  String get exit {
    return Intl.message(
      'Exit',
      name: 'exit',
      desc: '',
      args: [],
    );
  }

  /// `Playing: {title}`
  String playing_song(Object title) {
    return Intl.message(
      'Playing: $title',
      name: 'playing_song',
      desc: '',
      args: [title],
    );
  }

  /// `add to playlist`
  String get add_to_playlist {
    return Intl.message(
      'add to playlist',
      name: 'add_to_playlist',
      desc: '',
      args: [],
    );
  }

  /// `delete`
  String get delete {
    return Intl.message(
      'delete',
      name: 'delete',
      desc: '',
      args: [],
    );
  }

  /// `Color`
  String get color {
    return Intl.message(
      'Color',
      name: 'color',
      desc: '',
      args: [],
    );
  }

  /// `Dark theme`
  String get dark_theme {
    return Intl.message(
      'Dark theme',
      name: 'dark_theme',
      desc: '',
      args: [],
    );
  }

  /// `Follow system`
  String get follow_system {
    return Intl.message(
      'Follow system',
      name: 'follow_system',
      desc: '',
      args: [],
    );
  }

  /// `Always off`
  String get always_off {
    return Intl.message(
      'Always off',
      name: 'always_off',
      desc: '',
      args: [],
    );
  }

  /// `Always on`
  String get always_on {
    return Intl.message(
      'Always on',
      name: 'always_on',
      desc: '',
      args: [],
    );
  }

  /// `Primary color`
  String get primary_color {
    return Intl.message(
      'Primary color',
      name: 'primary_color',
      desc: '',
      args: [],
    );
  }

  /// `Main color for all page`
  String get primary_color_tip {
    return Intl.message(
      'Main color for all page',
      name: 'primary_color_tip',
      desc: '',
      args: [],
    );
  }

  /// `Accent color`
  String get accent_color {
    return Intl.message(
      'Accent color',
      name: 'accent_color',
      desc: '',
      args: [],
    );
  }

  /// `Customize your favorite color for APlayer`
  String get accent_color_tip {
    return Intl.message(
      'Customize your favorite color for APlayer',
      name: 'accent_color_tip',
      desc: '',
      args: [],
    );
  }

  /// `Searching`
  String get searching {
    return Intl.message(
      'Searching',
      name: 'searching',
      desc: '',
      args: [],
    );
  }

  /// `No lyrics`
  String get no_lrc {
    return Intl.message(
      'No lyrics',
      name: 'no_lrc',
      desc: '',
      args: [],
    );
  }

  /// `APlayer will be closed in {time} minutes`
  String will_stop_at_x(Object time) {
    return Intl.message(
      'APlayer will be closed in $time minutes',
      name: 'will_stop_at_x',
      desc: '',
      args: [time],
    );
  }

  /// `Fall Asleep to Music`
  String get timer {
    return Intl.message(
      'Fall Asleep to Music',
      name: 'timer',
      desc: '',
      args: [],
    );
  }

  /// `Cancel sleep timer`
  String get cancel_timer {
    return Intl.message(
      'Cancel sleep timer',
      name: 'cancel_timer',
      desc: '',
      args: [],
    );
  }

  /// `Start sleep timer`
  String get start_timer {
    return Intl.message(
      'Start sleep timer',
      name: 'start_timer',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'zh'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
