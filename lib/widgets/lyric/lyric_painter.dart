import 'package:flutter/material.dart';
import 'package:flutter_aplayer/main.dart';

import '../../lyric/lyric_parser.dart';

typedef OnClickTimeLine = void Function(Duration position);

class LyricPainter extends CustomPainter with ChangeNotifier {
  LyricPainter(this.lyricRows,
      {this.normalTextStyle,
      this.highLightTextStyle,
      this.timeLineTextStyle,
      this.linePadding,
      this.onClickTimeLine,
      required this.lyricMaxWidth}) {
    _timelinePaint.color = timeLineTextStyle?.color ?? Colors.grey;
  }

  double _scrollY = 0;
  final OnClickTimeLine? onClickTimeLine;
  final Path _timeLinePath = Path();
  final Paint _timelinePaint = Paint()..isAntiAlias = true;
  double lyricMaxWidth;
  double? linePadding;

  set drawTimeLine(value) {
    _drawTimeLine = value;
    notifyListeners();
  }

  bool _drawTimeLine = false;

  set scrollY(value) {
    _scrollY = value;
    notifyListeners();
  }

  get scrollY => _scrollY;

  int _currentLine = 0;

  get currentLine => _currentLine;

  set currentLine(value) {
    _currentLine = value;
    notifyListeners();
  }

  final TextPainter _textPainter =
      TextPainter(textDirection: TextDirection.ltr);
  final List<LyricRow> lyricRows;
  final TextStyle? normalTextStyle;
  final TextStyle? highLightTextStyle;
  final TextStyle? timeLineTextStyle;

  @override
  void paint(Canvas canvas, Size size) {
    if (lyricRows.isEmpty) {
      // _textPainter
      //   ..text = TextSpan(text: "暂无歌词", style: normalTextStyle)
      //   ..layout(maxWidth: lrcMaxWidth);
      // _textPainter.paint(
      //     canvas,
      //     Offset((size.width - _textPainter.width) / 2,
      //         (size.height - _textPainter.height) / 2));
      return;
    }

    final padding = (linePadding ?? 10);
    var currentY =
        _scrollY + (size.height - lyricRows[_currentLine].totalHeight) / 2;
    for (int i = 0; i < lyricRows.length; i++) {
      final lrcRow = lyricRows[i];

      _textPainter
        ..text = TextSpan(
            text: lrcRow.content,
            style: i == _currentLine ? highLightTextStyle : normalTextStyle)
        ..layout(maxWidth: lyricMaxWidth);

      _textPainter.paint(
          canvas, Offset((size.width - _textPainter.width) / 2, currentY));
      currentY += _textPainter.height;
      currentY += padding;
    }

    if (_drawTimeLine) {
      const dx = 16.0;
      final dy = size.height / 2;
      const indicatorSize = 16;
      const paddingRight = 8;

      _timelinePaint.style = PaintingStyle.fill;
      _timeLinePath.reset();
      _timeLinePath.moveTo(dx, dy - indicatorSize / 2);
      _timeLinePath.lineTo(dx + indicatorSize * 0.8, dy);
      _timeLinePath.lineTo(dx, dy + indicatorSize / 2);
      _timeLinePath.lineTo(dx, dy - indicatorSize / 2);
      _timeLinePath.close();
      canvas.drawPath(_timeLinePath, _timelinePaint);

      _textPainter
        ..text = TextSpan(
            text: lyricRows[_currentLine].timeStr, style: timeLineTextStyle)
        ..layout();
      _textPainter.paint(
          canvas,
          Offset(size.width - paddingRight - _textPainter.width,
              dy - _textPainter.height - 2));

      canvas.drawLine(Offset(dx + indicatorSize + 4, dy),
          Offset(size.width - paddingRight, dy), _timelinePaint);
    }
  }

  @override
  bool shouldRepaint(LyricPainter oldDelegate) {
    return oldDelegate.currentLine != currentLine;
  }

  void onTapDown(TapDownDetails e) {
    logger.i(
        'onTapDown, localP: ${e.localPosition}, globalP: ${e.globalPosition}, path: $_timeLinePath');
    if (_timeLinePath.contains(e.localPosition)) {
      onClickTimeLine?.call(lyricRows[_currentLine].time);
    }
  }
}
