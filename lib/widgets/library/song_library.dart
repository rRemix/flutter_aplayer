import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_aplayer/abilities.dart';
import 'package:flutter_aplayer/service/audio_handler_impl.dart';
import 'package:flutter_aplayer/widgets/library/abs_library.dart';
import 'package:flutter_audio/core.dart';
import 'package:get_it/get_it.dart';

class SongLibrary extends AbsLibrary {
  const SongLibrary({super.key});

  @override
  State<StatefulWidget> createState() {
    return _SongLibraryState();
  }
}

const _itemHeight = 64.0;

class _SongLibraryState extends AbsState<SongLibrary> {
  final _songs = <Song>[];
  final audioHandler = GetIt.I<AudioHandlerImpl>();

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
    });
  }

  @override
  Widget build(BuildContext context) {
    return SliverFixedExtentList.builder(
        itemExtent: _itemHeight,
        itemCount: _songs.length,
        itemBuilder: (context, index) {
          return SongItem(
            key: ValueKey(index),
            song: _songs[index],
            index: index,
            highLight: index == 0,
            callback: (index) {
              audioHandler.setQueue(_songs);
              audioHandler.setSong(_songs[index]);
              audioHandler.play();
            },
          );
        });
  }
}

typedef ClickCallback = void Function(int index);

class SongItem extends StatelessWidget {
  final Song song;
  final int index;
  final bool highLight;
  final ClickCallback? callback;

  const SongItem(
      {super.key,
      required this.song,
      required this.index,
      required this.highLight,
      this.callback});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    final cover = FutureBuilder(
        future: Abilities.instance.queryArtwork(song.id, ArtworkType.AUDIO),
        builder: (BuildContext context, AsyncSnapshot<Uint8List?> snapshot) {
          Widget img;
          if (snapshot.data != null) {
            img = Image.memory(
              snapshot.data!,
              width: 42,
              height: 42,
              fit: BoxFit.cover,
            );
          } else {
            img = Image.asset("images/ic_album_default.png",
                width: 42, height: 42, fit: BoxFit.cover);
          }

          return img;
        });
    final indicator = Container(
      width: 4,
      color: highLight ? themeData.primaryColor : Colors.transparent,
    );

    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: () {
          callback?.call(index);
        },
        child: Row(
          children: [
            indicator,
            Expanded(
                child: ListTile(
              leading: cover,
              title: Text(song.title),
              subtitle: Text(
                "${song.artist}-${song.album}",
                maxLines: 1,
              ),
              trailing: PopupMenuButton(
                icon: const Icon(Icons.more_vert_rounded),
                onSelected: (int value) {
                  debugPrint("select: $value");
                },
                itemBuilder: (context) {
                  return [
                    const PopupMenuItem(
                      value: 0,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [Icon(Icons.playlist_add), Text("添加到播放列表")],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 1,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [Icon(Icons.delete), Text("删除")],
                      ),
                    )
                  ];
                },
              ),
            ))
          ],
        ),
      ),
    );
  }
}
