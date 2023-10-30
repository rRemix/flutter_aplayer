

import 'package:flutter/material.dart';
import 'package:flutter_aplayer/widgets/library/abs_library.dart';

class PlayListLibrary extends AbsLibrary {
  const PlayListLibrary({super.key});

  @override
  State<StatefulWidget> createState() {
    return _PlayListLibraryState();
  }

}

class _PlayListLibraryState extends AbsState<PlayListLibrary> {
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Center(
        child: Text('Playlist'),
      ),
    );
  }

}