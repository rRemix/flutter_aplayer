import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_audio/core.dart';

import '../../abilities.dart';

class AlbumLibrary extends StatefulWidget {
  const AlbumLibrary({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AlbumLibraryState();
  }
}

class _AlbumLibraryState extends State<AlbumLibrary> {
  final _albums = <Album>[];

  @override
  void initState() {
    super.initState();
    _loadSongs();
  }

  _loadSongs() async {
    final albums = await Abilities.instance.queryAlbums();
    setState(() {
      _albums.clear();
      _albums.addAll(albums);
    });
  }

  @override
  Widget build(BuildContext context) {
    final mainAxisExtent = MediaQuery.of(context);
    return LayoutBuilder(builder: (context, constraints){
      var extent = mainAxisExtent.size.width / 2 + 62;
      return DecoratedBox(
        decoration:
        const BoxDecoration(color: Color.fromARGB(0xff, 0xf1, 0xf1, 0xf1)),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 0,
              mainAxisSpacing: 0,
              mainAxisExtent: extent),
          itemBuilder: (context, index) {
            return AlbumItem(
              album: _albums[index],
              index: index,
            );
          },
          itemCount: _albums.length,
        ),
      );
    });
  }
}

class AlbumItem extends StatelessWidget {
  final Album album;
  final int index;

  const AlbumItem({super.key, required this.album, required this.index});

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);

    final cover = LayoutBuilder(builder: (context, constraints) {
      return FutureBuilder(
          future:
              Abilities.instance.queryArtwork(album.albumId, ArtworkType.ALBUM),
          builder: (BuildContext context, AsyncSnapshot<Uint8List?> snapshot) {
            Widget img;
            if (snapshot.data != null) {
              img = Image.memory(
                snapshot.data!,
                width: constraints.maxWidth,
                height: constraints.maxWidth,
                fit: BoxFit.contain,
              );
            } else {
              img = Image.asset("images/ic_album_default.png",
                  width: constraints.maxWidth,
                  height: constraints.maxWidth,
                  fit: BoxFit.contain);
            }
            return ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: img,
            );
          });
    });

    final left = index % 2 == 0 ? 4.0 : 2.0;
    final right = index % 2 == 0 ? 2.0 : 4.0;
    const top = 2.0;

    return InkWell(
      onTap: () {
        debugPrint("click: $album");
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(left, top, right, top),
        child: Column(
          children: [
            cover,
            SizedBox(
              height: 60,
              child: DecoratedBox(
                decoration: const BoxDecoration(color: Colors.white),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, top: 4, bottom: 4),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              album.album,
                              style: themeData.textTheme.labelLarge,
                              maxLines: 1,
                            ),
                            Text(
                              album.artist,
                              style: themeData.textTheme.labelMedium,
                              maxLines: 1,
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: PopupMenuButton(
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
                                  children: [
                                    Icon(Icons.playlist_add),
                                    Text("添加到播放列表")
                                  ],
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
                      )
                    ],
                  ),
                ),
              ),
            )
            ,
          ],
        ),
      ),
    );
  }
}
