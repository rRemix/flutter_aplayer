

import 'package:flutter/material.dart';

class ArtistLibrary extends StatefulWidget {
  const ArtistLibrary({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ArtistLibraryState();
  }

}

class _ArtistLibraryState extends State<ArtistLibrary> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Artist"),
    );
  }

}