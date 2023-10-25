import 'package:flutter/material.dart';
import 'package:flutter_aplayer/abilities.dart';
import 'package:flutter_aplayer/service/audio_handler_impl.dart';
import 'package:flutter_aplayer/widgets/cover.dart';
import 'package:flutter_aplayer/widgets/library/abs_library.dart';
import 'package:flutter_audio/core.dart';

import '../../generated/l10n.dart';

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

    final cover = Cover(
      id: song.id,
      type: ArtworkType.AUDIO,
      size: 42,
    );
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
                title: Text(
                  song.title,
                  maxLines: 1,
                ),
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
                      PopupMenuItem(
                        value: 0,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(Icons.playlist_add),
                            Text(S.of(context).add_to_playlist)
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 1,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(Icons.delete),
                            Text(S.of(context).delete)
                          ],
                        ),
                      )
                    ];
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
