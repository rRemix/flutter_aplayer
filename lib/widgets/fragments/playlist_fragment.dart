

import 'package:flutter/material.dart';

class PlayListFragment extends StatefulWidget {
  const PlayListFragment({super.key});

  @override
  State<StatefulWidget> createState() {
    return _PlayListFragmentState();
  }

}

class _PlayListFragmentState extends State<PlayListFragment> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("PlayList"),
    );
  }

}