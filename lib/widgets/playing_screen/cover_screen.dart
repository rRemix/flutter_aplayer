import 'package:flutter/material.dart';
import 'package:flutter_audio/core.dart';
import 'package:get_it/get_it.dart';

import '../../service/audio_handler_impl.dart';
import '../cover.dart';

class CoverScreen extends StatelessWidget {
  final AudioHandlerImpl audioHandler = GetIt.I<AudioHandlerImpl>();
  final Callback? callback;
  CoverScreen({super.key, this.callback});

  @override
  Widget build(BuildContext context) {
    return Hero(
        tag: "cover",
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: DecoratedBox(
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
              child: AspectRatio(
                aspectRatio: 1,
                child: StreamCover(callback: callback,),
              ),
            ),
          ),
        ));
  }
}
