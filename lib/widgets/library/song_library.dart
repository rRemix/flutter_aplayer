import 'package:flutter/material.dart';
import 'package:flutter_aplayer/abilities.dart';
import 'package:flutter_aplayer/service/audio_handler_impl.dart';
import 'package:flutter_aplayer/widgets/cover.dart';
import 'package:flutter_aplayer/widgets/library/abs_library.dart';
import 'package:flutter_audio/core.dart';
import 'package:provider/provider.dart';

import '../../generated/l10n.dart';
import '../../setting/app_theme.dart';

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
  final ClickCallback? callback;

  const SongItem(
      {super.key,
      required this.song,
      required this.index,
      this.callback});

  @override
  Widget build(BuildContext context) {
    final appTheme = Provider.of<AppTheme>(context);

    final cover = Cover(
      id: song.id,
      type: ArtworkType.AUDIO,
      size: 42,
    );

    final content = Expanded(
      child: ListTile(
        leading: cover,
        title: Text(
          song.title,
          maxLines: 1,
          style: TextStyle(color: appTheme.primaryTextColor),
        ),
        subtitle: Text(
          '${song.artist}-${song.album}',
          maxLines: 1,
          style: TextStyle(color: appTheme.secondaryTextColor),
        ),
        trailing: PopupMenuButton(
          icon: const Icon(Icons.more_vert_rounded),
          onSelected: (int value) {
            debugPrint('select: $value');
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
    );

    return StreamBuilder(stream: audioHandler.mediaItem, builder: (context, snapshot) {

      return Material(
        color: appTheme.libraryColor,
        child: InkWell(
          onTap: () {
            callback?.call(index);
          },
          child: Row(
            children: [
              Container(
                width: 4,
                color: snapshot.data?.id == song.id.toString() ? appTheme.theme.primaryColor : Colors.transparent,
              ),
              content
            ],
          ),
        ),
      );
    });
  }
}
