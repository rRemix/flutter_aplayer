import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_audio/models/song.dart';
import 'package:flutter_audio/type/artwork_type.dart';

import '../abilities.dart';

const double bottomScreenHeight = 64;

class BottomScreen extends StatefulWidget {
  const BottomScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _BottomScreenState();
  }
}

class _BottomScreenState extends State<BottomScreen> {
  Song? _currentSong;
  final _songs = <Song>[];

  @override
  void initState() {
    super.initState();
    _loadSongs();
  }

  _loadSongs() async {
    final songs = await Abilities.instance.querySongs();
    setState(() {
      _songs.clear();
      _songs.addAll(songs);
      _currentSong = _songs.firstOrNull;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    final cover = FutureBuilder(
        future: _currentSong != null
            ? Abilities.instance
                .queryArtwork(_currentSong!.id, ArtworkType.AUDIO)
            : Future.value(null),
        builder: (BuildContext context, AsyncSnapshot<Uint8List?> snapshot) {
          Widget img;
          if (snapshot.data != null) {
            img = Image.memory(
              snapshot.data!,
              width: 48,
              height: 48,
              fit: BoxFit.contain,
            );
          } else {
            img = Image.asset("images/ic_album_default.png",
                width: 48, height: 48, fit: BoxFit.contain);
          }

          return ClipOval(
            child: img,
          );
        });

    return Container(
      width: MediaQuery.of(context).size.width,
      height: bottomScreenHeight,
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
              top: BorderSide(
                  width: 0.25, color: themeData.dividerColor.withAlpha(0x1f)))),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: cover,
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _currentSong?.displayName ?? "",
                  maxLines: 1,
                  style: themeData.textTheme.labelLarge,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  _currentSong?.album ?? "",
                  maxLines: 1,
                  style: themeData.textTheme.labelMedium,
                ),
              ],
            ),
          )),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Image.asset(
                  "images/ic_bottom_btn_play.png",
                  width: 48,
                  height: 48,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Image.asset(
                  "images/ic_bottom_btn_next.png",
                  width: 48,
                  height: 48,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
