

import 'package:flutter/material.dart';
import 'package:flutter_aplayer/widgets/library/abs_library.dart';

class GenreLibrary extends AbsLibrary {
  const GenreLibrary({super.key});

  @override
  State<StatefulWidget> createState() {
    return _GenreLibraryState();
  }

}

class _GenreLibraryState extends AbsState<GenreLibrary> {
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Center(
        child: Text("Genre"),
      ),
    );
  }

}