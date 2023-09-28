import 'package:flutter/material.dart';
import 'package:flutter_aplayer/widgets/fragments/album_fragment.dart';
import 'package:flutter_aplayer/widgets/fragments/arist_fragment.dart';
import 'package:flutter_aplayer/widgets/fragments/genre_fragment.dart';
import 'package:flutter_aplayer/widgets/fragments/playlist_fragment.dart';
import 'package:flutter_aplayer/widgets/fragments/song_fragment.dart';

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
    const SongFragment(),
    const AlbumFragment(),
    const ArtistFragment(),
    const GenreFragment(),
    const PlayListFragment()
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
