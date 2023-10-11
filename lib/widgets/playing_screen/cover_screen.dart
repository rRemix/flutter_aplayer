import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_audio/core.dart';

import '../../abilities.dart';

class CoverScreen extends StatelessWidget {
  final Song? song;

  const CoverScreen({super.key, required this.song});

  @override
  Widget build(BuildContext context) {
    final cover = FutureBuilder(
        future: song != null
            ? Abilities.instance.queryArtwork(song!.id, ArtworkType.AUDIO)
            : Future.value(null),
        builder: (BuildContext context, AsyncSnapshot<Uint8List?> snapshot) {
          debugPrint("data: ${snapshot.data}");
          Widget img;
          if (snapshot.data != null) {
            img = Image.memory(
              snapshot.data!,
              fit: BoxFit.cover,
            );
          } else {
            img = Image.asset(
              "images/ic_album_default.png",
              fit: BoxFit.cover,
            );
          }

          return DecoratedBox(
            decoration: BoxDecoration(
              boxShadow: <BoxShadow>[
                BoxShadow(color: Colors.black.withOpacity(0.5), offset: const Offset(0, 2), blurRadius: 6)
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: AspectRatio(
                aspectRatio: 1,
                child: img,
              ),
            ),
          );
        });

    return Hero(tag: "cover", child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: cover,
    ));
  }
}
