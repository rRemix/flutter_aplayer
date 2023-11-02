import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_aplayer/main.dart';
import 'package:flutter_aplayer/setting/app_theme.dart';
import 'package:flutter_aplayer/widgets/measure_size.dart';
import 'package:provider/provider.dart';

import '../generated/l10n.dart';

Timer? _timer;
StreamController<Duration> _controller = StreamController();

Stream<Duration> get timerStream => _controller.stream;

bool get timerRunning => _timer?.isActive ?? false;

void startTimer(Duration duration) {
  _timer?.cancel();
  _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
    if (timer.tick == duration.inSeconds) {
      logger.i('exit');
      exit(0);
    }
    _controller.add(Duration(seconds: duration.inSeconds - timer.tick));
  });
}

void stopTimer() {
  _timer?.cancel();
}

typedef OnProgressChange = void Function(int progress);

class TimerDialog extends StatelessWidget {
  const TimerDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final appTheme = Provider.of<AppTheme>(context);
    const progressMax = 7200;
    int progress = 0;

    return Dialog(
      insetPadding: const EdgeInsets.fromLTRB(64, 0, 64, 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 18, bottom: 12),
            child: Text(
              S.of(context).timer,
              style: TextStyle(
                  fontSize: 18,
                  color: appTheme.primaryTextColor,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
            child: SizedBox(
              width: 150,
              height: 150,
              child: TimerWidget(
                progressMax: progressMax,
                onProgressChange: (p) {
                  progress = p;
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12, bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  child: Text(
                    S.of(context).close,
                    style: TextStyle(color: appTheme.primaryTextColor),
                  ),
                  onPressed: () => Navigator.of(context).pop(), // 关闭对话框
                ),
                TextButton(
                  child: Text(
                    timerRunning
                        ? S.of(context).cancel_timer
                        : S.of(context).start_timer,
                    style: TextStyle(color: appTheme.primaryTextColor),
                  ),
                  onPressed: () {
                    if (timerRunning) {
                      stopTimer();
                    } else {
                      startTimer(Duration(seconds: progress));
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                              S.of(context).will_stop_at_x((progress ~/ 60).ceil()))));
                    }
                    //关闭对话框并返回true
                    Navigator.of(context).pop(true);
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class TimerWidget extends StatefulWidget {
  final int progressMax;
  final OnProgressChange? onProgressChange;

  const TimerWidget(
      {super.key, required this.progressMax, this.onProgressChange})
      : assert(progressMax > 0);

  @override
  State<StatefulWidget> createState() {
    return TimerWidgetState();
  }

  static TimerWidgetState of(BuildContext context) {
    final TimerWidgetState? result =
        context.findAncestorStateOfType<TimerWidgetState>();
    if (result != null) {
      return result;
    }
    throw FlutterError('can\'t find TimerWidgetState');
  }
}

class TimerWidgetState extends State<TimerWidget> {
  var progress = 0;
  var centerX = 0.0;
  var centerY = 0.0;
  final thumbRadius = 10.0;
  var radius = 0.0;
  late CirclePainter _painter;
  StreamSubscription? _subscription;
  final GlobalKey _key = GlobalKey();

  @override
  void initState() {
    super.initState();
    if (timerRunning) {
      _subscription = _controller.stream.listen((value) {
        progress = value.inSeconds;
        _painter.setProgress(progress, false);
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _subscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    _buildCustomPaint(context);

    return MeasureSize(
      child: GestureDetector(
        key: _key,
        onPanDown: (e) {
          if (_isTouchValid(e.localPosition.dx, e.localPosition.dy)) {
            _makeProgress(e.localPosition.dx, e.localPosition.dy);
          }
        },
        onPanUpdate: (e) {
          if (_isTouchValid(e.localPosition.dx, e.localPosition.dy)) {
            _makeProgress(e.localPosition.dx, e.localPosition.dy);
          }
        },
        child: CustomPaint(
          painter: _painter,
        ),
      ),
      onChange: (size) {
        centerX = size.width / 2;
        centerY = size.height / 2;
        radius =
            min(size.width / 2 - thumbRadius, size.height / 2 - thumbRadius);
      },
    );
  }

  void _makeProgress(double x, double y) {
    var rad = atan2(y - centerY, x - centerX);
    if (rad >= -0.5 * pi) {
      rad += 0.5 * pi;
    } else {
      rad += 2.5 * pi;
    }
    progress = (rad / (2.0 * pi) * widget.progressMax).toInt();
    _painter.setProgress(progress, true);
    widget.onProgressChange?.call(progress);
  }

  bool _isTouchValid(double x, double y) {
    if (timerRunning) {
      return false;
    }
    final distance = sqrt(pow(x - centerX, 2) + pow(y - centerY, 2));
    return distance >= radius - thumbRadius;
  }

  void _buildCustomPaint(BuildContext context) {
    _painter = CirclePainter(
        appTheme: Provider.of<AppTheme>(context),
        progressMax: widget.progressMax);
    _painter.thumbRadius = thumbRadius;
  }
}

class CirclePainter extends CustomPainter with ChangeNotifier {
  final _paint = Paint()..isAntiAlias = true;
  final _textPainter = TextPainter(textDirection: TextDirection.ltr);

  AppTheme appTheme;
  int progressMax;
  double? trackWidth;

  CirclePainter(
      {required this.appTheme, required this.progressMax, this.trackWidth})
      : assert(progressMax > 0);

  int _progress = 0;
  bool _setFromUser = false;

  void setProgress(int value, bool fromUser) {
    _progress = value;
    _setFromUser = fromUser;
    notifyListeners();
  }


  double _thumbRadius = 0.0;

  set thumbRadius(double value) {
    _thumbRadius = value;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final radius = min(size.width / 2, size.height / 2);
    final centerX = size.width / 2;
    final centerY = size.height / 2;

    // background track
    _paint.style = PaintingStyle.stroke;
    _paint.strokeWidth = trackWidth ?? 4;
    _paint.color = appTheme.theme.colorScheme.secondary.withOpacity(0.25);
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), radius, _paint);

    // active track
    final rad = _progress * pi * 2 / progressMax;
    _paint.color = appTheme.theme.colorScheme.secondary;
    canvas.drawArc(Rect.fromLTWH(0, 0, radius * 2, radius * 2), -pi * 0.5, rad,
        false, _paint);

    _paint.style = PaintingStyle.fill;
    // thumb
    canvas.drawCircle(
        Offset(centerX + sin(rad) * radius, centerY + (-cos(rad)) * radius),
        _thumbRadius,
        _paint);

    // minutes and seconds
    final minute = _progress ~/ 60;
    final sec = _progress % 60;

    final minSpan = TextSpan(
        text: '${minute < 10 ? '0$minute' : minute}',
        style: TextStyle(fontSize: 20, color: appTheme.primaryTextColor));
    final secSpan = TextSpan(
        text: '${sec < 10 ? '0$sec' : sec}',
        style: TextStyle(fontSize: 20, color: appTheme.primaryTextColor));
    const padding = 4;

    _paint.color = appTheme.bgColor;
    _paint.strokeWidth = 1.5;
    _textPainter.text = minSpan;
    _textPainter.layout(maxWidth: size.width);
    _textPainter.paint(
        canvas,
        Offset(size.width / 2 - padding - _textPainter.width,
            (size.height - _textPainter.height) / 2));
    canvas.drawLine(
        Offset(size.width / 2 - padding - _textPainter.width, size.height / 2),
        Offset(size.width / 2 - padding, size.height / 2),
        _paint);
    _paint.style = PaintingStyle.stroke;
    _paint.strokeWidth = 1;
    _paint.color = appTheme.secondaryTextColor;
    canvas.drawRect(
        Rect.fromLTWH(
            size.width / 2 - padding - _textPainter.width,
            (size.height - _textPainter.height) / 2,
            _textPainter.width,
            _textPainter.height),
        _paint);

    _textPainter.text = TextSpan(
        text: ':',
        style: TextStyle(fontSize: 20, color: appTheme.primaryTextColor));
    _textPainter.layout(maxWidth: size.width);
    _textPainter.paint(
        canvas,
        Offset((size.width - _textPainter.width) / 2,
            (size.height - _textPainter.height) / 2));

    _textPainter.text = secSpan;
    _textPainter.layout(maxWidth: size.width);
    _textPainter.paint(
        canvas,
        Offset(
            size.width / 2 + padding, (size.height - _textPainter.height) / 2));
    _paint.color = appTheme.bgColor;
    _paint.strokeWidth = 1.5;
    canvas.drawLine(
        Offset(size.width / 2 + padding, size.height / 2),
        Offset(size.width / 2 + padding + _textPainter.width, size.height / 2),
        _paint);
    _paint.style = PaintingStyle.stroke;
    _paint.strokeWidth = 1;
    _paint.color = appTheme.secondaryTextColor;
    canvas.drawRect(
        Rect.fromLTWH(
            size.width / 2 + padding,
            (size.height - _textPainter.height) / 2,
            _textPainter.width,
            _textPainter.height),
        _paint);
  }

  @override
  bool shouldRepaint(CirclePainter oldDelegate) {
    return false;
  }
}
