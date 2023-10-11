import 'package:flutter/material.dart';

class Indicator extends StatelessWidget {
  final int count;
  final int highLight;

  const Indicator({super.key, required this.count, required this.highLight})
      : assert(count > 0 && highLight >= 0);

  Widget _makeWidget(BuildContext context, bool highLight, bool needPadding) {
    ThemeData themeData = Theme.of(context);
    return Padding(
      padding: EdgeInsets.only(right: needPadding ? 4 : 0),
      child: Container(
        width: 8,
        height: 2,
        color: highLight
            ? themeData.primaryColor
            : themeData.primaryColor.withOpacity(0.3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];
    for (int i = 0; i < count; i++) {
      children.add(_makeWidget(context, i == highLight, i != count - 1));
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }
}
