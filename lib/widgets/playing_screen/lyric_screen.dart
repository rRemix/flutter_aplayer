import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_aplayer/lyric/lrc_parser.dart';
import 'package:flutter_aplayer/main.dart';
import 'package:flutter_aplayer/net/api.dart';
import 'package:flutter_aplayer/service/audio_handler_impl.dart';
import 'package:flutter_aplayer/widgets/lyric_view.dart';

import '../../generated/l10n.dart';

class LyricScreen extends StatelessWidget {
  final lyricParser = LrcParser();

  LyricScreen({super.key});

  Future<List<LrcRow>?> _getLrc(MediaItem? mediaItem) {
    if (mediaItem == null) {
      return Future.value(null);
    }

    return Api.searchtNeteaseSong(
            '${mediaItem.artist}-${mediaItem.title}', 0, 1)
        .then((nSong) {
      return Api.searchtNeteaseLyric(nSong?.result?.songs?.first.id ?? 0);
    }).then((nLyric) {
      if (nLyric == null || nLyric.lrc == null || nLyric.lrc?.lyric == null) {
        return Future.value(null);
      }

      return lyricParser.getLrcRows(nLyric.lrc!.lyric!);
    });
  }

  @override
  Widget build(BuildContext context) {
    final noLyric = Center(
      child: Text(S.of(context).no_lrc),
    );
    final searching = Center(
      child: Text(S.of(context).searching),
    );

    return LayoutBuilder(builder: (context, constraints) {
      logger.i(
          'minW: ${constraints.minWidth} maxW: ${constraints.maxWidth} minH: ${constraints.minHeight} : maxH: ${constraints.maxHeight}');
      return StreamBuilder(
          stream: audioHandler.mediaItem,
          builder: (context, snapshot) {
            return FutureBuilder(
                future: _getLrc(snapshot.data),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return searching;
                  }
                  final lrcRows = snapshot.data;
                  if (lrcRows == null || lrcRows.isEmpty) {
                    return noLyric;
                  } else {
                    return Center(
                      child: LyricView(lrcRows: lrcRows,),
                    );
                  }
                });
          });
    });
  }
}
