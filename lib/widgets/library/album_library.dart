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
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 4,
          mainAxisSpacing: 4,
          childAspectRatio: 0.8),
      itemBuilder: (context, index) {
        return AlbumItem(album: _albums[index]);
      },
      itemCount: _albums.length,
      padding: EdgeInsets.only(top: 20),
    );
  }
}

class AlbumItem extends StatelessWidget {
  final Album album;

  const AlbumItem({super.key, required this.album});

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);

    final cover = LayoutBuilder(builder: (context, constraints) {
      debugPrint("minW: ${constraints.minWidth} maxW: ${constraints.maxWidth}");
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
            return img;
          });
    });

    return InkWell(
      onTap: () {
        debugPrint("click: $album");
      },
      child: Column(
        children: [
          cover,
          Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                children: [
                  Expanded(
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
                    flex: 4,
                  ),
                  Expanded(
                    child: Icon(Icons.more_vert),
                    flex: 1,
                  )
                ],
              )),
        ],
      ),
    );
  }
}
