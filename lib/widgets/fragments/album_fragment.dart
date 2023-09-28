

import 'package:flutter/material.dart';

class AlbumFragment extends StatefulWidget {
  const AlbumFragment({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AlbumFragmentState();
  }

}

class _AlbumFragmentState extends State<AlbumFragment> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Album"),
    );
  }

}