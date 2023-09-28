import 'package:flutter/material.dart';
import 'package:flutter_aplayer/abilities.dart';
import 'package:flutter_aplayer/widgets/fragments/abs_fragment.dart';

class SongFragment extends AbsFragment {
  const SongFragment({super.key});

  _fetchSongs(Abilities abilities) {
    return abilities.audioPlugin.querySongs();
  }

  @override
  Widget createChildWidget(Abilities abilities){
    return Center(
      child: Text("songs: ${_fetchSongs(abilities)}"),
    );
  }
}
