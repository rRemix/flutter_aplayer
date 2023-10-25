import 'package:flutter/material.dart';

import '../cover.dart';

class CoverScreen extends StatelessWidget {
  final Callback? callback;

  const CoverScreen({super.key, this.callback});

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
                child: StreamCover(
                  callback: callback,
                ),
              ),
            ),
          ),
        ));
  }
}
