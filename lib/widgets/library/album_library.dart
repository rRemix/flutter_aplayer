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
    return ListView.builder(
      itemBuilder: (context, index) {
        final album = _albums[index];

        return ListTile(
          title: Text(album.album),
          subtitle: Text(album.artist),
          leading: Text("数量: ${album.count}"),
        );
      },
      itemCount: _albums.length,
    );
  }
}
