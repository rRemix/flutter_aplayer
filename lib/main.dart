import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_aplayer/abilities.dart';
import 'package:flutter_aplayer/constants/constants.dart';
import 'package:flutter_aplayer/service/audio_handler_impl.dart';
import 'package:flutter_aplayer/service/audio_service_provider.dart';
import 'package:flutter_aplayer/setting/app_theme.dart';
import 'package:flutter_aplayer/setting/setting_manager.dart';
import 'package:flutter_aplayer/utils.dart';
import 'package:flutter_aplayer/widgets/bottom_screen.dart';
import 'package:flutter_aplayer/widgets/cover.dart';
import 'package:flutter_aplayer/widgets/library/album_library.dart';
import 'package:flutter_aplayer/widgets/library/arist_library.dart';
import 'package:flutter_aplayer/widgets/library/genre_library.dart';
import 'package:flutter_aplayer/widgets/library/playlist_library.dart';
import 'package:flutter_aplayer/widgets/library/song_library.dart';
import 'package:flutter_aplayer/widgets/page/recent_page.dart';
import 'package:flutter_aplayer/widgets/page/setting_page.dart';
import 'package:flutter_aplayer/widgets/page/support_page.dart';
import 'package:flutter_aplayer/widgets/timer.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:logger/logger.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import 'generated/l10n.dart';

late Logger logger;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  await startService();
  runApp(const MyApp());
}

Future<void> startService() async {
  logger = Logger(printer: PrettyPrinter(methodCount: 0, printEmojis: false));

  Abilities.instance.setLogEnable(LogConfig());

  await initHive();

  final audioHandlerHelper = AudioHandlerHelper();
  final audioHandler = await audioHandlerHelper.getAudioHandler();

  GetIt.I.registerSingleton<AudioHandlerImpl>(audioHandler);
}

Future<void> initHive() async {
  final cacheDir = await getApplicationCacheDirectory();
  Hive.init(cacheDir.path);

  for (final box in hiveBoxes) {
    final boxName = box['name'].toString();
    await Hive.openBox(boxName);
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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
    SettingManager.instance.initialize(context);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => SettingManager.instance.appTheme,
        )
      ],
      child: Consumer<AppTheme>(
        builder: (context, appTheme, child) {
          return MaterialApp(
            themeMode: appTheme.themeMode,
            theme: appTheme.theme,
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              S.delegate
            ],
            locale: const Locale('zh', 'CN'),
            supportedLocales: S.delegate.supportedLocales,
            home: HomePage(),
          );
        },
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  final children = [
    const SongLibrary(),
    const AlbumLibrary(),
    const ArtistLibrary(),
    const GenreLibrary(),
    const PlayListLibrary()
  ];

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final titles = [
      S.of(context).tab_song,
      S.of(context).tab_album,
      S.of(context).tab_artist,
      S.of(context).tab_genre,
      S.of(context).tab_playlist
    ];
    final appTheme = Provider.of<AppTheme>(context);

    return Scaffold(
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
                        title: const Text('APlayer'),
                        leading: IconButton(
                          icon: const Icon(Icons.menu),
                          onPressed: () {
                            Scaffold.of(context).openDrawer();
                          },
                        ),
                        actions: [
                          IconButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return const TimerDialog();
                                    });
                              },
                              icon: const Icon(Icons.timer))
                        ],
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
                          color: appTheme.libraryColor,
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
    final appTheme = Provider.of<AppTheme>(context);
    final List<Map<String, dynamic>> menu = [
      {
        'text': S.of(context).song_library,
        'icon': Icon(
          Icons.library_music,
          color: appTheme.theme.colorScheme.secondary,
        ),
        'callback': () {
          Scaffold.of(context).closeDrawer();
        }
      },
      {
        'text': S.of(context).play_history,
        'icon': Icon(
          Icons.access_time,
          color: appTheme.theme.colorScheme.secondary,
        ),
        'callback': () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const RecentPage();
          }));
        }
      },
      {
        'text': S.of(context).support_developer,
        'icon':
            Icon(Icons.favorite, color: appTheme.theme.colorScheme.secondary),
        'callback': () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const SupportPage();
          }));
        }
      },
      {
        'text': S.of(context).setting,
        'icon':
            Icon(Icons.settings, color: appTheme.theme.colorScheme.secondary),
        'callback': () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const SettingPage();
          }));
        }
      },
      {
        'text': S.of(context).exit,
        'icon': Icon(
          Icons.exit_to_app,
          color: appTheme.theme.colorScheme.secondary,
        ),
        'callback': () {
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
                color: appTheme.theme.primaryColor,
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
                                      appTheme.theme.primaryColor, 0.8)),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 30),
                                child: Text(
                                  snapshot.hasData
                                      ? S
                                          .of(context)
                                          .playing_song(snapshot.data!.title)
                                      : '',
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
                          mnuItem['callback']();
                          _select(index);
                        },
                        child: ListTile(
                          leading: mnuItem['icon'],
                          title: Text(
                            mnuItem['text'],
                            style: const TextStyle(fontSize: 16),
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
