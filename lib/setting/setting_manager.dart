import 'package:flutter/material.dart';
import 'package:flutter_aplayer/main.dart';
import 'package:flutter_aplayer/setting/app_theme.dart';
import 'package:hive/hive.dart';


class SettingManager extends ChangeNotifier{
  SettingManager._();

  final Box? _settingBox =
      Hive.isBoxOpen('settings') ? Hive.box('settings') : null;

  late AppTheme _appTheme;
  AppTheme get appTheme => _appTheme;

  bool _initial = false;

  static SettingManager? _instance;

  static SettingManager get instance => _getInstance();

  static _getInstance() {
    _instance ??= SettingManager._();
    return _instance!;
  }

  void initialize(BuildContext context) {
    if (_initial) {
      return;
    }

    /// init theme
    _appTheme = AppTheme(_settingBox);
    _appTheme.initialize(context);

    _initial = true;
  }

}
