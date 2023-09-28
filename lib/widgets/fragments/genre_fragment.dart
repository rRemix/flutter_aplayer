

import 'package:flutter/material.dart';

class GenreFragment extends StatefulWidget {
  const GenreFragment({super.key});

  @override
  State<StatefulWidget> createState() {
    return _GenreFragmentState();
  }

}

class _GenreFragmentState extends State<GenreFragment> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Genre"),
    );
  }

}