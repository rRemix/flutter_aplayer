import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_aplayer/main.dart';
import 'package:flutter_aplayer/service/audio_handler_impl.dart';
import 'package:flutter_aplayer/setting/app_theme.dart';
import 'package:flutter_aplayer/widgets/playing_screen/cover_screen.dart';
import 'package:flutter_aplayer/widgets/playing_screen/indicator.dart';
import 'package:flutter_aplayer/widgets/playing_screen/lyric_screen.dart';
import 'package:flutter_aplayer/widgets/playing_screen/play_pause_button.dart';
import 'package:flutter_aplayer/widgets/playing_screen/queue_dialog.dart';
import 'package:flutter_aplayer/widgets/playing_screen/seekbar.dart';
import 'package:flutter_audio/type/artwork_type.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:provider/provider.dart';

import '../../abilities.dart';

class PlayingScreen extends StatefulWidget {
  const PlayingScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _PlayingScreenState();
  }
}

final _defaultPaletteColor =
    PaletteColor(const Color.fromARGB(0xff, 0x88, 0x88, 0x88), 100);

class _PlayingScreenState extends State<PlayingScreen>
    with TickerProviderStateMixin {
  final ValueNotifier<int> _selectedPage = ValueNotifier(0);
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<PaletteColor> _updatePalette(MediaItem? mediaItem) async {
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
            paletteColors.add(_defaultPaletteColor);
          }
          paletteColors.sort((a, b) => -a.population.compareTo(b.population));
          return paletteColors.first;
        }
        return _defaultPaletteColor;
      });
    }

    return Future.value(_defaultPaletteColor);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AppTheme>(
        builder: (context, appTheme, child) {
          return StreamBuilder(
            stream: audioHandler.mediaItem,
            builder: (context, snapshot) {
              final mediaItem = snapshot.data;

              return FutureBuilder(
                  future: _updatePalette(mediaItem),
                  builder: (context, snapshot) {
                    final paletteColor = snapshot.data ?? _defaultPaletteColor;
                    final child = Flex(
                      direction: Axis.vertical,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: MediaQuery.of(context).padding.top),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 8),
                                  child: Image.asset(
                                    'images/ic_playing_screen_back.png',
                                    width: 20,
                                    height: 20,
                                    color: paletteColor.titleTextColor,
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
                                          mediaItem?.title ?? '',
                                          style: TextStyle(
                                              fontSize: 18,
                                              color:
                                                  paletteColor.titleTextColor),
                                          maxLines: 1,
                                        ),
                                        Text(
                                          '${mediaItem?.album}-${mediaItem?.artist}',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color:
                                                  paletteColor.bodyTextColor),
                                          maxLines: 1,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: Image.asset(
                                    'images/ic_playing_screen_more.png',
                                    width: 20,
                                    height: 20,
                                    color: paletteColor.titleTextColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 12,
                          child: PageView(
                            onPageChanged: (int index) {
                              _selectedPage.value = index;
                            },
                            children: [
                              CoverScreen(
                                callback: (coverBytes) {
                                  // _updatePalette(coverBytes);
                                },
                              ),
                              LyricScreen()
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
                                  normalColor:
                                      paletteColor.color.withOpacity(0.3),
                                  highLightColor: paletteColor.color,
                                ),
                              );
                            },
                            valueListenable: _selectedPage,
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
                                  if (mediaItem != null) {
                                    audioHandler
                                        .seek(mediaItem.duration! * progress);
                                  }
                                },
                                trackColor: paletteColor.color,
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
                                splashRadius: 30,
                                highlightColor: paletteColor.color,
                                icon: Image.asset(
                                  'images/ic_playing_screen_mode_loop.png',
                                  width: 24,
                                  height: 24,
                                  color: paletteColor.color.withOpacity(0.5),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  audioHandler.skipToPrevious();
                                  audioHandler.play();
                                },
                                splashRadius: 30,
                                highlightColor: paletteColor.color,
                                icon: Image.asset(
                                  'images/ic_playing_screen_previous.png',
                                  width: 24,
                                  height: 24,
                                  color: paletteColor.color,
                                ),
                              ),
                              StreamBuilder(
                                  stream: audioHandler.playbackState,
                                  initialData: audioHandler.playbackState.value,
                                  builder: (context, snapshot) {
                                    return PlayPauseButton(
                                      initial: snapshot.data?.playing ?? false,
                                      backgroundColor: paletteColor.color,
                                      onTapCallback: (isPlay) {
                                        if (isPlay) {
                                          audioHandler.play();
                                        } else {
                                          audioHandler.pause();
                                        }
                                      },
                                    );
                                  }),
                              IconButton(
                                onPressed: () {
                                  audioHandler.skipToNext();
                                  audioHandler.play();
                                },
                                splashRadius: 30,
                                highlightColor: paletteColor.color,
                                icon: Image.asset(
                                  'images/ic_playing_screen_next.png',
                                  width: 24,
                                  height: 24,
                                  color: paletteColor.color,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  showModalBottomSheet(
                                      context: context,
                                      builder: (context) {
                                        return BottomSheet(
                                          onClosing: () {
                                          },
                                          builder: (context) {
                                            return const QueueDialog();
                                          },
                                          enableDrag: false,
                                        );
                                      });
                                },
                                splashRadius: 30,
                                highlightColor: paletteColor.color,
                                icon: Image.asset(
                                  'images/ic_playing_screen_list.png',
                                  width: 24,
                                  height: 24,
                                  color: paletteColor.color.withOpacity(0.5),
                                ),
                              )
                            ],
                          ),
                        ),
                        const Spacer(flex: 2)
                      ],
                    );

                    const surfaceColor = Colors.white;
                    final targetColor = snapshot.hasData
                        ? paletteColor.color.withOpacity(0.7)
                        : Colors.white;
                    final animation =
                        ColorTween(begin: surfaceColor, end: targetColor)
                            .animate(_controller);

                    _controller.reset();
                    _controller.stop();
                    if (snapshot.hasData) {
                      _controller.forward();
                    }
                    return AnimatedBuilder(
                      animation: animation,
                      child: child,
                      builder: (ctx, child) {
                        return DecoratedBox(
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [animation.value!, surfaceColor])),
                          child: child,
                        );
                      },
                    );
                  });
            },
          );
        },
      ),
    );
  }
}
