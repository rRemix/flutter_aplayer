import 'package:flutter/material.dart';

class PlayPauseButton extends StatefulWidget {
  final double? size;
  final double? iconSize;
  final bool? initial;
  final ValueChanged<bool>? callback;

  const PlayPauseButton(
      {super.key, this.size, this.iconSize, this.initial, this.callback});

  @override
  State<StatefulWidget> createState() {
    return PlayPauseButtonState();
  }

  static PlayPauseButtonState? of(BuildContext context) {
    final PlayPauseButtonState? result =
        context.findAncestorStateOfType<PlayPauseButtonState>();
    if (result != null) {
      return result;
    }

    return null;
  }
}

class PlayPauseButtonState extends State<PlayPauseButton>
    with TickerProviderStateMixin<PlayPauseButton> {
  late AnimationController _controller;
  bool isPlay = false;

  @override
  void initState() {
    _controller = AnimationController(vsync: this)
      ..drive(Tween(begin: 0, end: 1))
      ..duration = const Duration(milliseconds: 350);
    if (isPlay = widget.initial ?? false) {
      isPlay = true;
      _controller.value = 1;
    }
    super.initState();
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
          isPlay = false;
          widget.callback?.call(isPlay);
        } else if (_controller.status == AnimationStatus.dismissed) {
          _controller.forward();
          isPlay = true;
          widget.callback?.call(isPlay);
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
}
