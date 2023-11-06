import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_aplayer/service/audio_handler_impl.dart';

import '../cover.dart';

class CoverScreen extends StatelessWidget {
  final Callback? callback;

  const CoverScreen({super.key, this.callback});

  @override
  Widget build(BuildContext context) {
    return const AnimCover();
  }
}

class AnimCover extends StatefulWidget {
  const AnimCover({super.key});

  @override
  State<StatefulWidget> createState() {
    return AnimCoverState();
  }
}

class AnimCoverState extends State<AnimCover> with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scale;

  late AnimationController _positionController;
  late Animation<Offset> _position;

  MediaItem? _lastItem;

  @override
  void initState() {
    _scaleController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 150));

    _scale = Tween(begin: 0.85, end: 1.0).animate(
        CurvedAnimation(parent: _scaleController, curve: Curves.linear));

    _positionController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
    _positionController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {});
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _positionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final child = DecoratedBox(
      decoration: BoxDecoration(
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: Colors.black.withOpacity(0.5),
              offset: const Offset(0, 2),
              blurRadius: 6)
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: const StreamCover(),
      ),
    );

    final initialData = audioHandler.mediaItem.value;
    _lastItem = initialData;

    return LayoutBuilder(
      builder: (context, constraints) {
        final childSize = constraints.maxWidth * 0.9;
        final sizedBox = SizedBox(
          width: childSize,
          height: childSize,
          child: child,
        );

        return StreamBuilder(
            initialData: initialData,
            stream: audioHandler.mediaItem,
            builder: (context, snapshot) {
              if (_lastItem != snapshot.data) {
                _lastItem = snapshot.data;
                _position = Tween<Offset>(
                        begin: const Offset(0, 0),
                        end: Offset(audioHandler.next ? 1 : -1, 0))
                    .animate(CurvedAnimation(
                        parent: _positionController, curve: Curves.ease));
                _positionController.reset();
                _positionController.forward();
                return SlideTransition(position: _position, child: sizedBox);
              } else if (_positionController.status ==
                  AnimationStatus.completed) {
                _scaleController.reset();
                _scaleController.forward();
                return ScaleTransition(
                  scale: _scale,
                  child: sizedBox,
                );
              } else {
                return sizedBox;
              }
            });
      },
    );
  }
}
