import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_remake/core/bloc/home/home_cubit.dart';
import 'package:spotify_remake/pages/home/widgets/track_tile.dart';

class RecentTracksList extends StatefulWidget {
  const RecentTracksList({super.key});

  @override
  State<RecentTracksList> createState() => _RecentTracksListState();
}

class _RecentTracksListState extends State<RecentTracksList> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        final data = state.recentTracks;
        final homeCubit = context.read<HomeCubit>();

        if (data == null) {
          homeCubit.getRecentTracks();

          return const CircularProgressIndicator();
        } else {
          return Column(
            children: data
                .map((e) => TrackTile(track: e.track!, api: homeCubit.api))
                .toList(growable: false),
          );
        }
      },
    );
  }
}
