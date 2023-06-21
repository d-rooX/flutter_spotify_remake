import 'package:flutter/material.dart';
import 'package:spotify/spotify.dart';
import 'package:spotify_remake/pages/home/widgets/track_tile.dart';

class RecentTracksList extends StatelessWidget {
  final Iterable<PlayHistory> recentTracks;
  const RecentTracksList({super.key, required this.recentTracks});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: recentTracks
          .map(
            (e) => TrackTile(track: e.track!),
          )
          .toList(growable: false),
    );
  }
}
