import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_aplayer/main.dart';
import 'package:flutter_aplayer/service/audio_handler_impl.dart';
import 'package:flutter_aplayer/widgets/playing_screen/cover_screen.dart';
import 'package:flutter_aplayer/widgets/playing_screen/indicator.dart';
import 'package:flutter_aplayer/widgets/playing_screen/lyric_screen.dart';
import 'package:flutter_aplayer/widgets/playing_screen/play_pause_button.dart';
import 'package:flutter_aplayer/widgets/playing_screen/seekbar.dart';
import 'package:flutter_audio/type/artwork_type.dart';
import 'package:get_it/get_it.dart';
import 'package:palette_generator/palette_generator.dart';

import '../../abilities.dart';

class PlayingScreen extends StatefulWidget {
  const PlayingScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _PlayingScreenState();
  }
}

const _defaultColor = Color.fromARGB(0xff, 0x88, 0x88, 0x88);

class _PlayingScreenState extends State<PlayingScreen> {
  final AudioHandlerImpl audioHandlerImpl = GetIt.I<AudioHandlerImpl>();
  final ValueNotifier<int> _selected = ValueNotifier(0);

  @override
  void initState() {
    super.initState();
  }

  Future<Color> _updatePalette(MediaItem? mediaItem) async {
    if (mediaItem != null) {
      return Future(() async {
        final bytes = await Abilities.instance
            .queryArtwork(int.parse(mediaItem.id), ArtworkType.AUDIO);
        if (bytes != null) {
          final paletteGenerator =
              await PaletteGenerator.fromImageProvider(MemoryImage(bytes));
          final paletteColors = <PaletteColor>[];
          paletteColors.addAll(paletteGenerator.paletteColors);
          if (paletteColors.isEmpty) {
            paletteColors.add(PaletteColor(_defaultColor, 100));
          }
          paletteColors.sort((a, b) => -a.population.compareTo(b.population));
          return paletteColors.first.color;
        }
        return _defaultColor;
      });
    }

    return Future.value(_defaultColor);
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return Scaffold(
      body: StreamBuilder(
        stream: audioHandlerImpl.mediaItem,
        builder: (context, snapshot) {
          final mediaItem = snapshot.data;

          return FutureBuilder(
              future: _updatePalette(mediaItem),
              builder: (context, snapshot) {
                final startColor = snapshot.hasData ? snapshot.data!.withAlpha(0x7f) : Colors.white;
                const endColor = Colors.white;
                return SafeArea(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [startColor, endColor])),
                    child: Flex(
                      direction: Axis.vertical,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: Image.asset(
                                  "images/ic_playing_screen_back.png",
                                  width: 24,
                                  height: 24,
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                        mediaItem?.title ?? "",
                                        style: themeData
                                            .textTheme.headlineMedium!
                                            .copyWith(fontSize: 18),
                                        maxLines: 1,
                                      ),
                                      Text(
                                        "${mediaItem?.album}-${mediaItem?.artist}",
                                        style: themeData.textTheme.labelMedium!
                                            .copyWith(fontSize: 14),
                                        maxLines: 1,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: Image.asset(
                                  "images/ic_playing_screen_more.png",
                                  width: 24,
                                  height: 24,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 12,
                          child: PageView(
                            onPageChanged: (int index) {
                              _selected.value = index;
                            },
                            children: [
                              CoverScreen(
                                callback: (coverBytes) {
                                  // _updatePalette(coverBytes);
                                },
                              ),
                              const LyricScreen()
                            ]
                                .map((e) => LayoutBuilder(
                                        builder: (context, constraints) {
                                      return UnconstrainedBox(
                                        child: ConstrainedBox(
                                          constraints: BoxConstraints(
                                              minHeight: 0,
                                              maxHeight: constraints.maxHeight,
                                              minWidth: 0,
                                              maxWidth: constraints.maxWidth),
                                          child: e,
                                        ),
                                      );
                                    }))
                                .toList(),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: ValueListenableBuilder<int>(
                            builder: (context, value, child) {
                              return Center(
                                child: Indicator(
                                  count: 2,
                                  highLight: value,
                                ),
                              );
                            },
                            valueListenable: _selected,
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: SizedBox(
                              height: 30,
                              child: Seekbar(
                                listener: (seekbar, progress, fromUser) {
                                  debugPrint(
                                      "progress: $progress fromUser: $fromUser");
                                },
                                textStyle: const TextStyle(
                                    color:
                                        Color.fromARGB(0xff, 0x6b, 0x6b, 0x6b),
                                    fontSize: 12),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              IconButton(
                                onPressed: () {},
                                splashRadius: 24,
                                icon: Image.asset(
                                  "images/ic_playing_screen_mode_loop.png",
                                  width: 24,
                                  height: 24,
                                  color:
                                      themeData.primaryColor.withOpacity(0.4),
                                ),
                              ),
                              IconButton(
                                onPressed: () {},
                                splashRadius: 24,
                                icon: Image.asset(
                                  "images/ic_playing_screen_previous.png",
                                  width: 24,
                                  height: 24,
                                  color: themeData.primaryColor,
                                ),
                              ),
                              PlayPauseButton(
                                initial: false,
                                callback: (isPlay) {
                                  debugPrint("isPlay: $isPlay");
                                },
                              ),
                              IconButton(
                                onPressed: () {},
                                splashRadius: 24,
                                icon: Image.asset(
                                  "images/ic_playing_screen_next.png",
                                  width: 24,
                                  height: 24,
                                  color: themeData.primaryColor,
                                ),
                              ),
                              IconButton(
                                onPressed: () {},
                                splashRadius: 24,
                                icon: Image.asset(
                                  "images/ic_playing_screen_list.png",
                                  width: 24,
                                  height: 24,
                                  color:
                                      themeData.primaryColor.withOpacity(0.4),
                                ),
                              )
                            ],
                          ),
                        ),
                        const Spacer(flex: 2)
                      ],
                    ),
                  ),
                );
              });
        },
      ),
    );
  }
}
