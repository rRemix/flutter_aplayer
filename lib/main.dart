import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_aplayer/abilities.dart';
import 'package:flutter_aplayer/service/audio_handler_impl.dart';
import 'package:flutter_aplayer/service/audio_service_provider.dart';
import 'package:flutter_aplayer/widgets/bottom_screen.dart';
import 'package:flutter_aplayer/widgets/library/album_library.dart';
import 'package:flutter_aplayer/widgets/library/arist_library.dart';
import 'package:flutter_aplayer/widgets/library/genre_library.dart';
import 'package:flutter_aplayer/widgets/library/playlist_library.dart';
import 'package:flutter_aplayer/widgets/library/song_library.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

late Logger logger;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await startService();
  runApp(const MyApp());
}

Future<void> startService() async {
  logger = Logger(printer: PrettyPrinter(methodCount: 0, printEmojis: false));

  Abilities.instance.setLogEnable(false);

  final audioHandlerHelper = AudioHandlerHelper();
  final audioHandler = await audioHandlerHelper.getAudioHandler();

  GetIt.I.registerSingleton<AudioHandlerImpl>(audioHandler);
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final children = [
    const SongLibrary(),
    const AlbumLibrary(),
    const ArtistLibrary(),
    const GenreLibrary(),
    const PlayListLibrary()
  ];
  final titles = ["歌曲", "专辑", "艺术家", "流派", "播放列表"];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: bottomScreenHeight),
              child: DefaultTabController(
                length: titles.length,
                child: Scaffold(
                  body: NestedScrollView(
                    headerSliverBuilder:
                        (BuildContext context, bool innerBoxIsScrolled) {
                      return <Widget>[
                        SliverOverlapAbsorber(
                          handle:
                              NestedScrollView.sliverOverlapAbsorberHandleFor(
                                  context),
                          sliver: SliverAppBar(
                            title: const Text("APlayer"),
                            floating: true,
                            snap: true,
                            pinned: true,
                            forceElevated: innerBoxIsScrolled,
                            bottom: TabBar(
                              tabs: titles
                                  .map((String name) => Tab(text: name))
                                  .toList(),
                            ),
                          ),
                        ),
                      ];
                    },
                    body: TabBarView(
                      children: titles.asMap().keys.map((int index) {
                        return Builder(
                          builder: (BuildContext context) {
                            return Container(
                              color:
                                  const Color.fromARGB(0xff, 0xf1, 0xf1, 0xf1),
                              child: CustomScrollView(
                                key: PageStorageKey<String>(titles[index]),
                                slivers: <Widget>[
                                  SliverOverlapInjector(
                                    handle: NestedScrollView
                                        .sliverOverlapAbsorberHandleFor(
                                            context),
                                  ),
                                  children[index],
                                ],
                              ),
                            );
                          },
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ),
            const Positioned(bottom: 0, child: BottomScreen())
          ],
        ),
      ),
    );
  }
}
