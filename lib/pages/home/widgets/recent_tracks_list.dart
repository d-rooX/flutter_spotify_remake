import 'package:flutter/material.dart';
import 'package:spotify/spotify.dart';
import 'package:spotify_remake/core/utils/future_builder_wrapper.dart';

import 'track_tile.dart';

class RecentTracksList extends StatefulWidget {
  final SpotifyApi api;
  const RecentTracksList({super.key, required this.api});

  @override
  State<RecentTracksList> createState() => _RecentTracksListState();
}

class _RecentTracksListState extends State<RecentTracksList> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilderWrapper(
      future: widget.api.me.recentlyPlayed().first(),
      onDone: (context, data) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          children: data.items!
              .map((e) => TrackTile(track: e.track!, api: widget.api))
              .toList(growable: false),
        ),
      ),
      onLoading: (BuildContext context) => const CircularProgressIndicator(),
    );
  }
}
