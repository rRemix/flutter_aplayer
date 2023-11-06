

import 'package:flutter/material.dart';
import 'package:flutter_aplayer/widgets/library/abs_library.dart';

class ArtistLibrary extends AbsLibrary {
  const ArtistLibrary({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ArtistLibraryState();
  }

}

class _ArtistLibraryState extends AbsState<ArtistLibrary> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SliverToBoxAdapter(
      child: Center(
        child: Text('Artist'),
      ),
    );
  }

}