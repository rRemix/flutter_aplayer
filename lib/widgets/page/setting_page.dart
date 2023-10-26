import 'package:flutter/material.dart';
import 'package:flutter_aplayer/setting/app_theme.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';

import '../../generated/l10n.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _SettingPageState();
  }
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppTheme>(builder: (context, appTheme, child) {
      return Scaffold(
          appBar: AppBar(
            title: Text(S.of(context).setting)
          ),
          body: ColoredBox(
            color: appTheme.bgColor,
            child: const CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: CommonBlock(),
                ),
                SliverToBoxAdapter(
                  child: ColorBlock(),
                )
              ],
            ),
          ));
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class ColorBlock extends StatefulWidget {
  const ColorBlock({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ColorBlockState();
  }
}

class _ColorBlockState extends State<ColorBlock> {
  late Color _pickColor;
  late bool _pickForPrimary;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = Provider.of<AppTheme>(context);
    final themeData = appTheme.theme;

    final themeOptions = [
      S.of(context).follow_system,
      S.of(context).always_off,
      S.of(context).always_on,
    ];

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context).color,
            style: TextStyle(color: themeData.primaryColor),
          ),
          GestureDetector(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    final children = List.generate(
                        themeOptions.length,
                        (index) => GestureDetector(
                              child: Row(
                                children: [
                                  Radio(
                                      activeColor: appTheme.theme.primaryColor,
                                      value: themeOptions[index],
                                      groupValue: themeOptions[
                                          appTheme.themeMode.index],
                                      onChanged: (val) {
                                        Navigator.of(context).pop();
                                        _changeThemeMode(context, appTheme, index);
                                      }),
                                  Text(themeOptions[index])
                                ],
                              ),
                              onTap: () {
                                Navigator.of(context).pop();
                                _changeThemeMode(context, appTheme, index);
                              },
                            ));
                    return AlertDialog(
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: children,
                      ),
                    );
                  });
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(S.of(context).dark_theme, style: TextStyle(color: appTheme.primaryTextColor)),
                        Text(themeOptions[appTheme.themeMode.index], style: TextStyle(color: appTheme.secondaryTextColor))
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          _buildColorWidget(context, appTheme, true),
          _buildColorWidget(context, appTheme, false)
        ],
      ),
    );
  }

  void _changeThemeMode(BuildContext context, AppTheme appTheme, int index) {
    appTheme.saveThemeMode(context, index);
  }

  Padding _buildColorWidget(
      BuildContext context, AppTheme appTheme, bool primary) {
    ThemeData themeData = appTheme.theme;
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: SingleChildScrollView(
                  child: ColorPicker(
                    pickerColor: primary
                        ? themeData.colorScheme.primary
                        : themeData.colorScheme.secondary,
                    onColorChanged: (color) {
                      _changeColor(color, primary);
                    },
                  ),
                ),
                actions: <Widget>[
                  ElevatedButton(
                    child: Text(S.of(context).confirm),
                    onPressed: () {
                      appTheme.saveColor(_pickColor, _pickForPrimary);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        },
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(primary
                      ? S.of(context).primary_color
                      : S.of(context).accent_color, style: TextStyle(color: appTheme.primaryTextColor),),
                  Text(primary
                      ? S.of(context).primary_color_tip
                      : S.of(context).accent_color_tip, style: TextStyle(color: appTheme.secondaryTextColor))
                ],
              ),
            ),
            SizedBox(
              width: 30,
              height: 30,
              child: ClipOval(
                child: ColoredBox(
                  color: primary
                      ? themeData.colorScheme.primary
                      : themeData.colorScheme.secondary,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _changeColor(Color value, bool primary) {
    _pickForPrimary = primary;
    _pickColor = value;
  }
}

class CommonBlock extends StatelessWidget {
  const CommonBlock({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [],
    );
  }
}
