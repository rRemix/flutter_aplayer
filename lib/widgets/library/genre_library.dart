

import 'package:flutter/material.dart';

class GenreLibrary extends StatefulWidget {
  const GenreLibrary({super.key});

  @override
  State<StatefulWidget> createState() {
    return _GenreLibraryState();
  }

}

class _GenreLibraryState extends State<GenreLibrary> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Genre"),
    );
  }

}