import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_aplayer/abilities.dart';
import 'package:flutter_aplayer/widgets/library/abs_library.dart';
import 'package:flutter_audio/core.dart';

class SongLibrary extends AbsLibrary {
  const SongLibrary({super.key});

  @override
  State<StatefulWidget> createState() {
    return _SongLibraryState();
  }
}

class _SongLibraryState extends AbsState<SongLibrary> {
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: _songs.length,
        itemBuilder: (context, index) {
          return SongItem(
            song: _songs[index],
            highLight: index == 0,
          );
        });
  }
}

class SongItem extends StatelessWidget {
  final Song song;
  final bool highLight;

  const SongItem({super.key, required this.song, required this.highLight});

  @override
  Widget build(BuildContext context) {
    const itemHeight = 64.0;
    final cover = FutureBuilder(
        future: Abilities.instance.queryArtwork(song.id, ArtworkType.AUDIO),
        builder: (BuildContext context, AsyncSnapshot<Uint8List?> snapshot) {
          Widget img;
          if (snapshot.data != null) {
            img = Image.memory(
              snapshot.data!,
              width: 42,
              height: 42,
              fit: BoxFit.contain,
            );
          } else {
            img = Image.asset("images/ic_album_default.png",
                width: 42, height: 42, fit: BoxFit.contain);
          }

          return img;
        });
    final indicator = Container(
      width: 4,
      height: itemHeight,
      color: highLight ? Theme.of(context).primaryColor : Colors.transparent,
    );

    return InkWell(
      onTap: () {
        //TODO
        debugPrint("click: $song");
      },
      child: SizedBox(
        width: double.infinity,
        height: itemHeight,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
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
