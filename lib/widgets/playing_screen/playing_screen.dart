import 'package:flutter/material.dart';
import 'package:flutter_aplayer/widgets/indicator.dart';
import 'package:flutter_aplayer/widgets/playing_screen/cover_screen.dart';
import 'package:flutter_aplayer/widgets/playing_screen/lyric_screen.dart';
import 'package:flutter_audio/models/song.dart';

import '../../abilities.dart';

class PlayingScreen extends StatefulWidget {
  const PlayingScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _PlayingScreenState();
  }
}

class _PlayingScreenState extends State<PlayingScreen> {
  Song? _currentSong;
  final ValueNotifier<int> _selected = ValueNotifier(0);

  @override
  void initState() {
    super.initState();
    _loadSongs();
  }

  _loadSongs() async {
    final songs = await Abilities.instance.querySongs();
    setState(() {
      _currentSong = songs.firstOrNull;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return Scaffold(
      body: SafeArea(
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
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            _currentSong?.title ?? "",
                            style: themeData.textTheme.headlineMedium!
                                .copyWith(fontSize: 18),
                            maxLines: 1,
                          ),
                          Text(
                            "${_currentSong?.album}-${_currentSong?.artist}",
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
                    song: _currentSong,
                  ),
                  const LyricScreen()
                ]
                    .map((e) => LayoutBuilder(builder: (context, constraints) {
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
              child: Container(
                width: double.infinity,
                color: Colors.green,
                child: const Text("seekbar"),
              ),
            ),
            Expanded(
              flex: 4,
              child: Container(
                width: double.infinity,
                color: Colors.black,
                child: const Text("bottom control"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
