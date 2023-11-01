import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_aplayer/main.dart';
import 'package:flutter_aplayer/service/audio_handler_impl.dart';
import 'package:flutter_aplayer/widgets/lyric/lyric_painter.dart';

import '../../lyric/lyric_parser.dart';

class LyricWidget extends StatefulWidget {
  final List<LyricRow> lyricRows;
  final double? lyricMaxWidth;
  final TextStyle? normalTextStyle;
  final TextStyle? highLightTextStyle;
  final TextStyle? timeLineTextStyle;
  final double? linePadding;

  const LyricWidget(
      {super.key,
      this.lyricMaxWidth,
      this.normalTextStyle,
      this.highLightTextStyle,
      this.timeLineTextStyle,
      this.linePadding,
      required this.lyricRows});

  @override
  State<StatefulWidget> createState() {
    return LyricWidgetState();
  }

  static LyricWidgetState of(BuildContext context) {
    final LyricWidgetState? result =
        context.findAncestorStateOfType<LyricWidgetState>();
    if (result != null) {
      return result;
    }
    throw FlutterError('can\'t find LyricWidgetState');
  }
}

class LyricWidgetState extends State<LyricWidget>
    with SingleTickerProviderStateMixin {
  final TextPainter _painter = TextPainter(textDirection: TextDirection.ltr);
  var totalHeight = 0.0;
  double? lyricMaxWidth;
  late List<LyricRow> lyricRows;
  late TextStyle normalTextStyle;
  late TextStyle highLightTextStyle;
  late TextStyle timeLineTextStyle;
  late double linePadding;
  late LyricPainter _lyricPainter;
  late AnimationController _controller;
  late Animation<double> _animation;
  Timer? _timer;
  StreamSubscription? _stream;

  @override
  void initState() {
    super.initState();

    _setFields();

    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
    _controller.addListener(() {
      if (_controller.status == AnimationStatus.forward || _controller.status == AnimationStatus.completed) {
        _lyricPainter.scrollY = _animation.value;
      }
    });
    _stream = audioHandler.positionStream.listen((event) {
      final progress = event;
      for (int i = lyricRows.length - 1; i >= 0; i--) {
        if (progress >= lyricRows[i].time) {
          if (_lyricPainter.currentLine != i) {
            _lyricPainter.currentLine = i;
            _lyricPainter.scrollY = -_computeScrollYByLine(i);
          }
          break;
        }
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _calculateTotalHeight();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
    _stream?.cancel();
    _controller.dispose();
  }

  void _calculateTotalHeight() {
    totalHeight = 0;
    for (final lyric in lyricRows) {
      lyric.contentHeight = _getSingleLineHeight(lyric.content);
      if (lyric.hasTranslate()) {
        lyric.translateHeight = _getSingleLineHeight(lyric.translate);
      }
      lyric.totalHeight = lyric.translateHeight + lyric.contentHeight;
      totalHeight += lyric.totalHeight;
      totalHeight += linePadding;
    }
  }

  double _getSingleLineHeight(String content) {
    _painter
      ..text = TextSpan(text: content, style: normalTextStyle)
      ..layout(maxWidth: lyricMaxWidth!);

    return _painter.height;
  }

  double _computeScrollYByLine(int line) {
    if (lyricRows.isEmpty) {
      return 0;
    }
    var scrollY = 0.0;
    var i = 0;
    while (i < lyricRows.length && i < line) {
      scrollY += (lyricRows[i].totalHeight + linePadding);
      i++;
    }

    return scrollY;
  }

  int _computeLineByScrollY(double scrollY) {
    var totalY = 0.0;
    var line = 0;

    while (line < lyricRows.length) {
      totalY += (linePadding + lyricRows[line].totalHeight);
      if (totalY > scrollY.abs()) {
        return line;
      }
      line++;
    }
    return line - 1;
  }

  @override
  Widget build(BuildContext context) {
    if (lyricMaxWidth == null || lyricMaxWidth == double.infinity) {
      lyricMaxWidth = MediaQuery.of(context).size.width;
    }

    _buildPainter(context);
    _lyricPainter.scrollY = _computeScrollYByLine(_lyricPainter.currentLine);

    return LayoutBuilder(builder: (context, constraints) {
      return GestureDetector(
        onVerticalDragUpdate: (e) {
          _timer?.cancel();
          double newScrollY = (_lyricPainter.scrollY + e.delta.dy);
          if (newScrollY < 0 && newScrollY > -totalHeight) {
            final currentRow = _computeLineByScrollY(newScrollY);
            _lyricPainter.drawTimeLine = true;
            _lyricPainter.currentLine = currentRow;
            _lyricPainter.scrollY = newScrollY;
          }
        },
        onVerticalDragEnd: (e) {
          var newScrollY = _computeScrollYByLine(_lyricPainter.currentLine);
          if (_lyricPainter.scrollY < newScrollY) {
            _startScroll(newScrollY);
          }
          _timer = Timer(const Duration(seconds: 3), () {
            _lyricPainter.drawTimeLine = false;
          });
        },
        onTapDown: (e) {
          _lyricPainter.onTapDown(e);
        },
        child: CustomPaint(
          painter: _lyricPainter,
          size: Size(constraints.maxWidth, constraints.maxHeight),
        ),
      );
    });
  }

  void _startScroll(double newScrollY) {
    _animation =
        Tween<double>(begin: _lyricPainter.scrollY, end: -newScrollY)
            .animate(_controller);
    _controller.reset();
    _controller.forward();
  }

  void _buildPainter(BuildContext context) {
    _lyricPainter = LyricPainter(widget.lyricRows,
        normalTextStyle: normalTextStyle,
        highLightTextStyle: highLightTextStyle,
        timeLineTextStyle: timeLineTextStyle,
        linePadding: linePadding, onClickTimeLine: (position) {
      if (audioHandler.playbackState.value.playing == false) {
        audioHandler.play();
      }
      audioHandler.seek(position);
    }, lyricMaxWidth: lyricMaxWidth!);
  }

  @override
  void didUpdateWidget(LyricWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    _timer?.cancel();
    _setFields();
    _calculateTotalHeight();
  }

  void _setFields() {
    lyricRows = widget.lyricRows;
    lyricMaxWidth = widget.lyricMaxWidth;
    normalTextStyle = widget.normalTextStyle ??
        const TextStyle(color: Colors.white, fontSize: 15);
    highLightTextStyle = widget.highLightTextStyle ??
        const TextStyle(color: Colors.black, fontSize: 15);
    timeLineTextStyle = widget.timeLineTextStyle ??
        const TextStyle(color: Colors.white, fontSize: 12);
    linePadding = widget.linePadding ?? 10.0;
  }
}
