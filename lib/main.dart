import 'package:flutter/material.dart';
import 'package:flutter_aplayer/widgets/library/album_library.dart';
import 'package:flutter_aplayer/widgets/library/arist_library.dart';
import 'package:flutter_aplayer/widgets/library/genre_library.dart';
import 'package:flutter_aplayer/widgets/library/playlist_library.dart';
import 'package:flutter_aplayer/widgets/library/song_library.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  late TabController _tabController;
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
    _tabController = TabController(length: children.length, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('APlayer'),
          bottom: TabBar(
            tabs: titles.map((e) => Text(e)).toList(),
            controller: _tabController,
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: children,
        ),
      ),
    );
  }
}
