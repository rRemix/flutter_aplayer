import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_aplayer/widgets/library/abs_library.dart';
import 'package:flutter_audio/core.dart';

import '../../abilities.dart';

class AlbumLibrary extends AbsLibrary {
  const AlbumLibrary({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AlbumLibraryState();
  }
}

const double _contentHeight = 56.0;

class _AlbumLibraryState extends AbsState<AlbumLibrary> {
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
    final mediaQuery = MediaQuery.of(context);
    final mainAxisExtent = mediaQuery.size.width / 2 + _contentHeight;

    return SliverGrid.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 0,
          mainAxisSpacing: 0,
          mainAxisExtent: mainAxisExtent),
      itemBuilder: (context, index) {
        return AlbumItem(
          album: _albums[index],
          index: index,
        );
      },
      itemCount: _albums.length,
    );
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
                fit: BoxFit.cover,
              );
            } else {
              img = Image.asset("images/ic_album_default.png",
                  width: constraints.maxWidth,
                  height: constraints.maxWidth,
                  fit: BoxFit.cover);
            }
            return ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: img,
            );
          });
    });

    final left = index % 2 == 0 ? 4.0 : 2.0;
    final right = index % 2 == 0 ? 2.0 : 4.0;

    return Padding(
      padding: EdgeInsets.fromLTRB(left, 4, right, 0),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        child: InkWell(
          onTap: () {
            //TODO
            debugPrint("click: $album");
          },
          child: Column(
            children: [
              cover,
              SizedBox(
                height: _contentHeight,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
            ],
          ),
        ),
      ),
    );
  }
}
