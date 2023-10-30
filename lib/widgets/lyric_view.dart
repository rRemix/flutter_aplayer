import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../lyric/lrc_parser.dart';

class LyricView extends StatefulWidget {
  final List<LrcRow>? lrcRows;

  const LyricView({super.key, this.lrcRows});

  @override
  State<StatefulWidget> createState() {
    return _LyricViewState();
  }
}

TextPainter _painter = TextPainter(textDirection: TextDirection.ltr);
TextStyle _normalStyle = const TextStyle(fontSize: 16);

class _LyricViewState extends State<LyricView> {
  var totalHeight = 0.0;
  var shouldCalculate = true;
  var maxWidth = 0.0;

  @override
  void initState() {
    super.initState();
  }

  void _calculateLrcRowHeight(BoxConstraints constraints) {
    var lrcRows = widget.lrcRows;
    if (lrcRows != null) {
      totalHeight = 0;
      maxWidth = constraints.maxWidth;
      for (final lrcRow in lrcRows) {
        lrcRow.contentHeight =
            _getSingleLineHeight(lrcRow.content, constraints.maxWidth);
        if (lrcRow.hasTranslate()) {
          lrcRow.translateHeight =
              _getSingleLineHeight(lrcRow.translate, constraints.maxWidth);
        }
        lrcRow.totalHeight = lrcRow.translateHeight + lrcRow.contentHeight;
        totalHeight += lrcRow.totalHeight;
      }
    }
  }

  double _getSingleLineHeight(String content, double maxWidth) {
    _painter
      ..text = TextSpan(text: content, style: _normalStyle)
      ..layout(maxWidth: maxWidth);

    return _painter.height;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (shouldCalculate) {
        _calculateLrcRowHeight(constraints);
        shouldCalculate = false;
      }

      return CustomPaint(
        painter: _LyricPainter(state: this),
        size: Size(constraints.maxWidth, constraints.maxHeight),
      );
    });
  }

  final equality = const ListEquality();

  @override
  void didUpdateWidget(LyricView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (equality.equals(oldWidget.lrcRows, widget.lrcRows)) {
      shouldCalculate = true;
    }
  }
}

class _LyricPainter extends CustomPainter {
  final _LyricViewState state;

  _LyricPainter({super.repaint, required this.state});

  @override
  void paint(Canvas canvas, Size size) {
    if (state.widget.lrcRows != null) {
      final maxW = state.maxWidth;
      canvas.save();

      for (final lrcRow in state.widget.lrcRows!) {
        _painter
          ..text = TextSpan(text: lrcRow.content, style: _normalStyle)
          ..layout();

        _painter.paint(canvas, Offset((maxW - _painter.width) / 2, 0));
        canvas.translate(0, _painter.height);
      }
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
