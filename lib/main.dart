import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_aplayer/abilities.dart';
import 'package:flutter_aplayer/constants/constants.dart';
import 'package:flutter_aplayer/recent_page.dart';
import 'package:flutter_aplayer/service/audio_handler_impl.dart';
import 'package:flutter_aplayer/service/audio_service_provider.dart';
import 'package:flutter_aplayer/setting_page.dart';
import 'package:flutter_aplayer/support_page.dart';
import 'package:flutter_aplayer/utils.dart';
import 'package:flutter_aplayer/widgets/bottom_screen.dart';
import 'package:flutter_aplayer/widgets/cover.dart';
import 'package:flutter_aplayer/widgets/library/album_library.dart';
import 'package:flutter_aplayer/widgets/library/arist_library.dart';
import 'package:flutter_aplayer/widgets/library/genre_library.dart';
import 'package:flutter_aplayer/widgets/library/playlist_library.dart';
import 'package:flutter_aplayer/widgets/library/song_library.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

late Logger logger;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await startService();
  runApp(const MyApp());
}

Future<void> startService() async {
  logger = Logger(printer: PrettyPrinter(methodCount: 0, printEmojis: false));

  Abilities.instance.setLogEnable(false);

  await initHive();

  final audioHandlerHelper = AudioHandlerHelper();
  final audioHandler = await audioHandlerHelper.getAudioHandler();

  GetIt.I.registerSingleton<AudioHandlerImpl>(audioHandler);
}

Future<void> initHive() async {
  final cacheDir = await getApplicationCacheDirectory();
  Hive.init(cacheDir.path);

  for (final box in hiveBoxes) {
    final boxName = box["name"].toString();
    await Hive.openBox(boxName);
  }
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
        drawer: _Drawer(),
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: bottomScreenHeight),
              child: DefaultTabController(
                length: titles.length,
                child: NestedScrollView(
                  headerSliverBuilder:
                      (BuildContext context, bool innerBoxIsScrolled) {
                    return <Widget>[
                      SliverOverlapAbsorber(
                        handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                            context),
                        sliver: SliverAppBar(
                          title: const Text("APlayer"),
                          leading: IconButton(
                            icon: const Icon(Icons.menu),
                            onPressed: () {
                              Scaffold.of(context).openDrawer();
                            },
                          ),
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
                            color: const Color.fromARGB(0xff, 0xf1, 0xf1, 0xf1),
                            child: CustomScrollView(
                              key: PageStorageKey<String>(titles[index]),
                              slivers: <Widget>[
                                SliverOverlapInjector(
                                  handle: NestedScrollView
                                      .sliverOverlapAbsorberHandleFor(context),
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
            const Positioned(bottom: 0, child: BottomScreen())
          ],
        ),
      ),
    );
  }
}

class _Drawer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _DrawerState();
  }
}

class _DrawerState extends State<_Drawer> {
  final AudioHandlerImpl audioHandler = GetIt.I<AudioHandlerImpl>();
  int _selectIndex = 0;

  void _select(int index) {
    setState(() {
      _selectIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final List<Map<String, dynamic>> menu = [
      {
        "text": "歌曲库",
        "icon": Icon(
          Icons.library_music,
          color: themeData.primaryColor,
        ),
        "callback": () {
          Scaffold.of(context).closeDrawer();
        }
      },
      {
        "text": "最近播放",
        "icon": Icon(
          Icons.access_time,
          color: themeData.primaryColor,
        ),
        "callback": () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const RecentPage();
          }));
        }
      },
      {
        "text": "支持开发者",
        "icon": Icon(Icons.favorite, color: themeData.primaryColor),
        "callback": () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const SupportPage();
          }));
        }
      },
      {
        "text": "设置",
        "icon": Icon(Icons.settings, color: themeData.primaryColor),
        "callback": () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const SettingPage();
          }));
        }
      },
      {
        "text": "退出",
        "icon": Icon(
          Icons.exit_to_app,
          color: themeData.primaryColor,
        ),
        "callback": () {
          exit(0);
        }
      },
    ];
    const drawerDefaultColor = Colors.white;
    const drawerEffectColor = Color.fromARGB(0xff, 0xf5, 0xf5, 0xf5);
    return Drawer(
      width: 280,
      backgroundColor: drawerDefaultColor,
      child: MediaQuery.removePadding(
          context: context,
          removeTop: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                color: themeData.primaryColor,
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 48, bottom: 10),
                      child: Center(
                        child: SizedBox(
                          width: 108,
                          height: 108,
                          child: StreamCover(),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 16),
                      child: StreamBuilder(
                          stream: audioHandler.mediaItem,
                          builder: (context, snapshot) {
                            return DecoratedBox(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  color: Utils.shiftColor(
                                      themeData.primaryColor, 0.8)),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 30),
                                child: Text(
                                  snapshot.hasData
                                      ? "正在播放: ${snapshot.data?.title}"
                                      : "",
                                  maxLines: 1,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 14),
                                ),
                              ),
                            );
                          }),
                    )
                  ],
                ),
              ),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    var mnuItem = menu[index];
                    return ColoredBox(
                      color: _selectIndex == index
                          ? drawerEffectColor
                          : drawerDefaultColor,
                      child: GestureDetector(
                        onTap: () {
                          mnuItem["callback"]();
                          _select(index);
                        },
                        child: ListTile(
                          leading: mnuItem["icon"],
                          title: Text(
                            mnuItem["text"],
                            style: const TextStyle(fontSize: 15),
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: menu.length,
                  itemExtent: 56,
                ),
              ))
            ],
          )),
    );
  }
}
