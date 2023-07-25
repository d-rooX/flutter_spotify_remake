import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/spotify.dart' as spotapi;
import 'package:spotify_remake/core/bloc/bloc_exports.dart';
import 'package:spotify_remake/pages/home/widgets/covers_slider.dart';
import 'package:spotify_remake/pages/home/widgets/home_widget.dart';
import 'package:spotify_remake/pages/home/widgets/my_playlists_carousel.dart';
import 'package:spotify_remake/pages/home/widgets/track_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return DecoratedBox(
      decoration: const BoxDecoration(color: Colors.black),
      child: SingleChildScrollView(
        dragStartBehavior: DragStartBehavior.down,
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            SizedBox(height: topPadding),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Good evening",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 23,
                    ),
                  ),
                  Spacer(),
                  Icon(Icons.notifications_none_rounded, size: 30),
                  SizedBox(width: 35),
                  Icon(Icons.settings, size: 30)
                ],
              ),
            ),
            const HomeWidget(
              title: "Your playlists",
              child: MyPlaylistsCarousel(),
            ),
            const RecentTracksHomeWidget(),
            const RecommendationsHomeWidget(),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }
}

class RecentTracksHomeWidget extends StatelessWidget {
  const RecentTracksHomeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen: (previous, current) =>
          previous.recentTracks != current.recentTracks,
      builder: (context, state) {
        Iterable<spotapi.PlayHistory>? recentTracks = state.recentTracks;
        if (recentTracks == null) {
          final homeCubit = context.read<HomeCubit>();
          homeCubit.getRecentTracks();
          recentTracks = [];
        }
        final tracks = recentTracks.map((e) => e.track!);

        return HomeWidget(
          title: "Recent tracks",
          height: 80,
          expandedHeight: 500,
          onExpanded: TrackList(tracks: tracks),
          child: CoversSlider(tracks: tracks),
        );
      },
    );
  }
}

class RecommendationsHomeWidget extends StatelessWidget {
  const RecommendationsHomeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen: (previous, current) =>
          previous.recommendations != current.recommendations,
      builder: (context, state) {
        List<spotapi.TrackSimple>? recs = state.recommendations?.tracks;
        if (recs == null) {
          context.read<HomeCubit>().getRecommendations();
          recs = [];
        }

        return HomeWidget(
          title: "Recommendations",
          height: 80,
          expandedHeight: 500,
          onExpanded: TrackList(tracks: recs),
          child: CoversSlider(tracks: recs),
        );
      },
    );
  }
}
