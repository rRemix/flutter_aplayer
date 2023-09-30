

import 'package:flutter/material.dart';

class PlayListLibrary extends StatefulWidget {
  const PlayListLibrary({super.key});

  @override
  State<StatefulWidget> createState() {
    return _PlayListLibraryState();
  }

}

class _PlayListLibraryState extends State<PlayListLibrary> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("PlayList"),
    );
  }

}