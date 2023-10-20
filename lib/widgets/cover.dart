import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter_audio/type/artwork_type.dart';
import 'package:get_it/get_it.dart';

import '../abilities.dart';
import '../service/audio_handler_impl.dart';

final AudioHandlerImpl _audioHandler = GetIt.I<AudioHandlerImpl>();

class StreamCover extends StatelessWidget {
  final BoxFit? boxFit;
  final double? size;

  const StreamCover({super.key, this.boxFit, this.size});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _audioHandler.mediaItem,
        builder: (context, snapshot) {
          final mediaItem = snapshot.data;
          return Cover(
              id: mediaItem != null ? int.parse(mediaItem.id) : null,
              type: ArtworkType.AUDIO);
        });
  }
}

class Cover extends StatelessWidget {
  final num? id;
  final ArtworkType type;
  final BoxFit? boxFit;
  final double? size;

  const Cover(
      {super.key,
      required this.id,
      required this.type,
      this.size,
      this.boxFit});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: id != null
            ? Abilities.instance.queryArtwork(id!, ArtworkType.AUDIO)
            : Future.value(null),
        builder: (BuildContext context, AsyncSnapshot<Uint8List?> snapshot) {
          Widget img;
          if (snapshot.data != null) {
            img = Image.memory(
              snapshot.data!,
              fit: boxFit ?? BoxFit.cover,
              width: size,
              height: size,
            );
          } else {
            img = Image.asset(
              "images/ic_album_default.png",
              fit: boxFit ?? BoxFit.cover,
              width: size,
              height: size,
            );
          }

          return img;
        });
  }
}
