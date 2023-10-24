import 'package:flutter/material.dart';

class PlayPauseButton extends StatefulWidget {
  final double? size;
  final double? iconSize;
  final bool initial;
  final ValueChanged<bool>? onTapCallback;

  const PlayPauseButton(
      {super.key,
      required this.initial,
      this.size,
      this.iconSize,
      this.onTapCallback});

  @override
  State<StatefulWidget> createState() {
    return PlayPauseButtonState();
  }

  static PlayPauseButtonState of(BuildContext context) {
    final PlayPauseButtonState? result =
        context.findAncestorStateOfType<PlayPauseButtonState>();
    if (result != null) {
      return result;
    }

    throw FlutterError("can't find PlayPauseButtonState");
  }
}

class PlayPauseButtonState extends State<PlayPauseButton>
    with TickerProviderStateMixin<PlayPauseButton> {
  late AnimationController _controller;
  bool _isPlay = false;

  @override
  void initState() {
    _controller = AnimationController(vsync: this)
      ..drive(Tween(begin: 0, end: 1))
      ..duration = const Duration(milliseconds: 350);
    if (_isPlay = widget.initial) {
      _isPlay = true;
      _controller.value = 1;
    }
    super.initState();
  }

  void setPlay(bool isPlay) {
    if (isPlay) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    _isPlay = isPlay;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (_controller.status == AnimationStatus.completed) {
          _controller.reverse();
          _isPlay = false;
          widget.onTapCallback?.call(_isPlay);
        } else if (_controller.status == AnimationStatus.dismissed) {
          _controller.forward();
          _isPlay = true;
          widget.onTapCallback?.call(_isPlay);
        }
      },
      child: ClipOval(
        child: Container(
          color: Theme.of(context).primaryColor,
          alignment: Alignment.center,
          width: widget.size ?? 56,
          height: widget.size ?? 56,
          child: AnimatedIcon(
            icon: AnimatedIcons.play_pause,
            progress: _controller,
            size: widget.iconSize ?? 36,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  @override
  void didUpdateWidget(PlayPauseButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initial != widget.initial) {
      setPlay(widget.initial);
    }
  }
}
