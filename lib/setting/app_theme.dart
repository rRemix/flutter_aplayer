import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../main.dart';

const _keyColorPrimary = "key_color_primary";
const _keyColorAccent = "key_color_accent";
const _keyThemeMode = "key_theme_mode";

class AppTheme with ChangeNotifier {
  final Box? _settingBox;

  AppTheme(this._settingBox);

  late ThemeData _theme;

  ThemeData get theme => _theme;

  late ThemeMode _themeMode;

  ThemeMode get themeMode => _themeMode;

  bool _light = false;

  Color get _lightPrimaryTextColor =>
      const Color.fromARGB(0xff, 0x1c, 0x1b, 0x19);

  Color get _lightSecondaryTextColor =>
      const Color.fromARGB(0xff, 0x6d, 0x6c, 0x69);

  Color get _darkPrimaryTextColor => Colors.white;

  Color get _darkSecondaryTextColor =>
      const Color.fromARGB(0xff, 0x6c, 0x6c, 0x6c);

  Color get primaryTextColor =>
      _light ? _lightPrimaryTextColor : _darkPrimaryTextColor;

  Color get secondaryTextColor =>
      _light ? _lightSecondaryTextColor : _darkSecondaryTextColor;

  Color get _lightBGColor => Colors.white;

  Color get _darkBGColor => Colors.black;

  Color get bgColor => _light ? _lightBGColor : _darkBGColor;

  Color get _lightLibraryColor => const Color.fromARGB(0xff, 0xf1, 0xf1, 0xf1);

  Color get _darkLibraryColor => Colors.black;

  Color get libraryColor => _light ? _lightLibraryColor : _darkLibraryColor;

  Color get _lightRippleColor => const Color.fromARGB(0x1f, 0, 0, 0);

  Color get _darkRippleColor => const Color.fromARGB(0x33, 0xff, 0xff, 0xff);

  Color get rippleColor => _light ? _lightRippleColor : _darkRippleColor;

  void initialize(BuildContext context) {
    _theme = Theme.of(context);

    final settingBox = _settingBox;
    if (settingBox != null) {
      Color? primaryColor;
      Color? accentColor;

      if (settingBox.containsKey(_keyColorPrimary)) {
        primaryColor = Color(settingBox.get(_keyColorPrimary));
      }
      if (settingBox.containsKey(_keyColorAccent)) {
        accentColor = Color(settingBox.get(_keyColorAccent));
      }

      _theme = _theme.copyWith(
          primaryColor: primaryColor,
          appBarTheme:
              _theme.appBarTheme.copyWith(backgroundColor: primaryColor),
          indicatorColor: Colors.white,
          colorScheme: _theme.colorScheme
              .copyWith(primary: primaryColor, secondary: accentColor));
    }

    _themeMode = ThemeMode.values[
        _settingBox?.get(_keyThemeMode, defaultValue: ThemeMode.light.index)];
    _updateBrightness(context, _themeMode.index);
  }

  void saveColor(Color color, bool primary) {
    _settingBox?.put(primary ? _keyColorPrimary : _keyColorAccent, color.value);
    _theme = _theme.copyWith(
        primaryColor: primary ? color : _theme.colorScheme.primary,
        appBarTheme: _theme.appBarTheme.copyWith(
            backgroundColor:
                primary ? color : _theme.appBarTheme.backgroundColor),
        colorScheme: _theme.colorScheme.copyWith(
            primary: primary ? color : _theme.colorScheme.primary,
            secondary: !primary ? color : _theme.colorScheme.secondary));
    logger.i('hasListeners: $hasListeners');
    notifyListeners();
  }

  /// 0 - follow system
  /// 1 - always off
  /// 2 - always on
  void saveThemeMode(BuildContext context, int mode) {
    _themeMode = ThemeMode.values[mode];
    _settingBox?.put(_keyThemeMode, mode);
    _updateBrightness(context, mode);
    notifyListeners();
  }

  void _updateBrightness(BuildContext context, int mode) {
    if (mode == ThemeMode.system.index) {
      _light = MediaQuery.of(context).platformBrightness == Brightness.light;
    } else {
      _light = mode == ThemeMode.light.index;
    }
  }
}
