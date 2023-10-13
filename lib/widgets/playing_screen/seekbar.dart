import 'dart:ui';

import 'package:flutter/material.dart';

typedef OnSeekBarChangedListener = void Function(
    Seekbar seekbar, double progress, bool fromUser);

const _trackHeight = 2.0;
const _thumbWidth = 2.0;
const _thumbHeight = 6.0;

class Seekbar extends StatefulWidget {
  final OnSeekBarChangedListener? listener;
  final TextStyle? textStyle;

  const Seekbar({super.key, this.listener, this.textStyle});

  @override
  State<StatefulWidget> createState() {
    return _SeekbarState();
  }
}

class _SeekbarState extends State<Seekbar> {
  ///0-100
  double progress = 0;
  double lastX = 0;

  _SeekbarState();

  @override
  void didUpdateWidget(Seekbar oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            "00:00",
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
              _updateProgress(detail.localPosition.dx, maxWidth);
            },
            onHorizontalDragStart: (detail) {
              _updateProgress(detail.localPosition.dx, maxWidth);
            },
            child: Container(
              height: constraints.maxHeight,
              alignment: Alignment.center,
              color: Colors.red,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container( ///track
                    color: Colors.white,
                    height: _trackHeight,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container( ///track
                        color: theme.primaryColor,
                        height: _trackHeight,
                        width: clampDouble((progress / 100.0) * maxWidth, 0, maxWidth - _thumbWidth),
                      ),
                      Container( ///thumb
                        color: theme.primaryColor,
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            "00:00",
            style: widget.textStyle,
          ),
        ),
      ],
    );
  }

  void _updateProgress(double lastX, double maxWidth) {
    final newProgress = clampDouble(((lastX / maxWidth) * 100), 0, 100);
    if (newProgress != progress) {
      setState(() {
        this.lastX = lastX;
        progress = newProgress;
        widget.listener?.call(widget, progress, true);
      });
    }
  }
}
