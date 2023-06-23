import 'package:flutter/material.dart';
import 'package:spotify/spotify.dart';
import 'package:spotify_remake/pages/home/widgets/track_tile.dart';

class TrackList extends StatelessWidget {
  final Iterable<TrackSimple> tracks;
  const TrackList({super.key, required this.tracks});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children:
            tracks.map((e) => TrackTile(track: e)).toList(growable: false),
      ),
    );
  }
}
