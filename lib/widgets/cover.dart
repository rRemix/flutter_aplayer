import 'dart:collection';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../abilities.dart';
import '../service/audio_handler_impl.dart';

typedef Callback = Function(Uint8List coverBytes);

class StreamCover extends StatelessWidget {
  final BoxFit? boxFit;
  final double? size;
  final Callback? callback;

  const StreamCover({super.key, this.boxFit, this.size, this.callback});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        initialData: audioHandler.mediaItem.value,
        stream: audioHandler.mediaItem,
        builder: (context, snapshot) {
          final mediaItem = snapshot.data;
          return Cover(
            id: mediaItem != null ? int.parse(mediaItem.id) : null,
            size: size,
            type: ArtworkType.AUDIO,
            callback: callback,
          );
        });
  }
}

class Cover extends StatelessWidget {
  final int? id;
  final ArtworkType type;
  final BoxFit? boxFit;
  final double? size;
  final Callback? callback;

  const Cover({
    super.key,
    required this.id,
    required this.type,
    this.size,
    this.boxFit,
    this.callback,
  });

  @override
  Widget build(BuildContext context) {
    if (id != null) {
      final data = getCache(id!.toInt(), type.index);
      if (data != null) {
        return _buildImage(data);
      }
    }

    return FutureBuilder(
        future: id != null
            ? Abilities.instance.queryArtwork(id!, ArtworkType.AUDIO)
            : Future.value(null),
        builder: (BuildContext context, AsyncSnapshot<Uint8List?> snapshot) {
          return _buildImage(snapshot.data);
        });
  }

  Widget _buildImage(Uint8List? data) {
    Widget img;
    if (data != null) {
      callback?.call(data);
      _putCache(id!.toInt(), type.index, data);
      img = Image.memory(
        data,
        fit: boxFit ?? BoxFit.cover,
        width: size,
        height: size,
      );
    } else {
      img = Image.asset(
        'images/ic_album_default.png',
        fit: boxFit ?? BoxFit.cover,
        width: size,
        height: size,
      );
    }
    return img;
  }

  static final LinkedHashMap<String, Uint8List> _cache = LinkedHashMap();

  String _key(int id, int type) {
    return '${type}_$id';
  }

  void _putCache(int id, int type, Uint8List data) {
    if (_cache.length >= 100) {
      _cache.remove(_cache.keys.last);
    }

    _cache[_key(id, type)] = data;
  }

  Uint8List? getCache(int id, int type) {
    return _cache[_key(id, type)];
  }
}
