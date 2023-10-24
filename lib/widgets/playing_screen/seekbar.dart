import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_aplayer/main.dart';
import 'package:flutter_aplayer/utils.dart';
import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';

import '../../service/audio_handler_impl.dart';

typedef OnSeekBarChangedListener = void Function(
    Seekbar seekbar, double progress, bool fromUser);

const _trackHeight = 2.0;
const _thumbWidth = 2.0;
const _thumbHeight = 6.0;

class Seekbar extends StatefulWidget {
  final OnSeekBarChangedListener? listener;
  final TextStyle? textStyle;
  final Color trackColor;

  const Seekbar({super.key, this.listener, this.textStyle, required this.trackColor});

  @override
  State<StatefulWidget> createState() {
    return _SeekbarState();
  }
}

class _SeekbarState extends State<Seekbar> {
  final AudioHandlerImpl audioHandlerImpl = GetIt.I<AudioHandlerImpl>();

  ///0-1
  double progress = 0;
  double lastX = 0;
  late Duration duration;
  bool tracking = false;

  _SeekbarState();

  @override
  void didUpdateWidget(Seekbar oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return StreamBuilder(
      stream: Rx.combineLatest2(
          audioHandlerImpl.durationStream, audioHandlerImpl.positionStream,
          (duration, position) {
        return PositionData(duration ?? Duration.zero, position);
      }),
      builder: (context, snapshot) {
        duration = snapshot.data?.duration ?? Duration.zero;
        Duration position;
        if (tracking) {
          position = duration * progress;
        } else {
          position = snapshot.data?.position ?? Duration.zero;
          final newProgress = duration.inMilliseconds > 0
              ? _calculateProgress(position.inMilliseconds, duration.inMilliseconds)
              : 0.0;
          progress = newProgress;
        }
        final remain = duration - position;

        return Row(
          children: [
            Container(
              width: 56,
              alignment: Alignment.center,
              child: Text(
                Utils.getTime(position),
                style: widget.textStyle,
              ),
            ),
            Expanded(child: LayoutBuilder(builder: (context, constraints) {
              final maxWidth = constraints.maxWidth;

              return GestureDetector(
                onHorizontalDragUpdate: (detail) {
                  if (detail.delta.dx > 0) {
                    _updateProgress(lastX + detail.delta.dx, maxWidth);
                  } else if (detail.delta.dx < 0) {
                    _updateProgress(lastX + detail.delta.dx, maxWidth);
                  }
                },
                onHorizontalDragDown: (detail) {
                  _onStartTackingTouch();
                  _updateProgress(detail.localPosition.dx, maxWidth);
                },
                onHorizontalDragStart: (detail) {
                  _updateProgress(detail.localPosition.dx, maxWidth);
                },
                onHorizontalDragEnd: (detail) {
                  _onStopTrackingTouch();
                },
                child: Container(
                  color: Colors.transparent,
                  height: constraints.maxHeight,
                  alignment: Alignment.center,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        ///track background
                        color: const Color.fromARGB(0xff, 0xef, 0xee, 0xed),
                        height: _trackHeight,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            ///track
                            color: widget.trackColor,
                            height: _trackHeight,
                            width: clampDouble(
                                progress * maxWidth, 0, maxWidth - _thumbWidth),
                          ),
                          Container(
                            ///thumb
                            color: widget.trackColor,
                            width: _thumbWidth,
                            height: _thumbHeight,
                          )
                        ],
                      )
                    ],
                  ),
                ),
              );
            })),
            Container(
              alignment: Alignment.center,
              width: 56,
              child: Text(
                Utils.getTime(remain),
                style: widget.textStyle,
              ),
            ),
          ],
        );
      },
    );
  }

  double _calculateProgress(num current, num total) {
    return clampDouble(current / total, 0, 1);
  }

  void _onStartTackingTouch() {
    tracking = true;
  }

  void _onStopTrackingTouch() {
    tracking = false;
  }

  void _updateProgress(double lastX, double maxWidth) {
    final newProgress = _calculateProgress(lastX, maxWidth);
    if (newProgress != progress) {
      setState(() {
        this.lastX = lastX;
        progress = newProgress;
        widget.listener?.call(widget, progress, true);
      });
    }
  }
}

class PositionData {
  final Duration duration;
  final Duration position;

  PositionData(this.duration, this.position);
}
