import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_aplayer/widgets/playing_screen/playing_screen.dart';
import 'package:flutter_audio/type/artwork_type.dart';
import 'package:get_it/get_it.dart';

import '../abilities.dart';
import '../main.dart';
import '../service/audio_handler_impl.dart';

const double bottomScreenHeight = 64;

class BottomScreen extends StatefulWidget {
  const BottomScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _BottomScreenState();
  }
}

class _BottomScreenState extends State<BottomScreen> {
  final audioHandler = GetIt.I<AudioHandlerImpl>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return StreamBuilder(
      stream: audioHandler.mediaItem,
      builder: (context, snapshot) {
        final mediaItem = snapshot.data;

        final cover = FutureBuilder(
            future: mediaItem != null
                ? Abilities.instance
                    .queryArtwork(int.parse(mediaItem.id), ArtworkType.AUDIO)
                : Future.value(null),
            builder:
                (BuildContext context, AsyncSnapshot<Uint8List?> snapshot) {
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
                      width: 0.25,
                      color: themeData.dividerColor.withAlpha(0x1f)))),
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return const PlayingScreen();
              }));
            },
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Hero(
                    tag: "cover",
                    child: cover,
                  ),
                ),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        mediaItem?.displayTitle ?? "",
                        maxLines: 1,
                        style: themeData.textTheme.labelLarge,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        mediaItem?.album ?? "",
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
                      child: StreamBuilder(
                        builder: (context, snapshot) {
                          final playbackState = snapshot.data;
                          return GestureDetector(
                            onTap: () {
                              if (playbackState != null) {
                                if (playbackState.playing) {
                                  audioHandler.pause();
                                } else {
                                  audioHandler.play();
                                }
                              }
                            },
                            child: Image.asset(
                              playbackState?.playing == true
                                  ? "images/ic_bottom_btn_stop.png"
                                  : "images/ic_bottom_btn_play.png",
                              width: 48,
                              height: 48,
                            ),
                          );
                        },
                        stream: audioHandler.playbackState,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: GestureDetector(
                        onTap: () {
                          audioHandler.skipToNext();
                        },
                        child: Image.asset(
                          "images/ic_bottom_btn_next.png",
                          width: 48,
                          height: 48,
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
