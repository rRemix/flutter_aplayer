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
