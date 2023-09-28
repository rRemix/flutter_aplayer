import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_audio/core.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _audioPlugin = FlutterAudio();
  final _songs = <Song>[];

  @override
  void initState() {
    super.initState();
    loadSongs();
  }

  Future<bool> checkPermissions() async {
    final bool? hasPermissions = await _audioPlugin.permissionsStatus();
    if (hasPermissions == true) {
      return true;
    }
    return await _audioPlugin.permissionsRequest() ?? false;
  }

  Future<void> loadSongs() async {
    if (await checkPermissions()) {
      final songs = await _audioPlugin.querySongs(
          sortType: SortTypeSong.TITLE, orderType: OrderType.ASC);
      if (songs != null) {
        setState(() {
          _songs.clear();
          _songs.addAll(songs);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('APlayer'),
        ),
        body: Center(
          child: Text('Songs: $_songs'),
        ),
      ),
    );
  }
}
