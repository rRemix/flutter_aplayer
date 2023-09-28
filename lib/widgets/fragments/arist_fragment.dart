

import 'package:flutter/material.dart';

class ArtistFragment extends StatefulWidget {
  const ArtistFragment({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ArtistFragmentState();
  }

}

class _ArtistFragmentState extends State<ArtistFragment> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Artist"),
    );
  }

}