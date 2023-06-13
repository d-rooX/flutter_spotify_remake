import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:spotify_remake/core/bloc/api/api_bloc.dart';
import 'package:spotify_remake/pages/home/widgets/my_playlists_carousel.dart';
import 'package:spotify_remake/pages/home/widgets/recent_tracks_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blueGrey,
              Colors.black,
            ],
          ),
        ),
        child: SafeArea(
          child: ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(
                          Ionicons.search,
                          color: Colors.green,
                          size: 32,
                        ),
                        Icon(
                          Ionicons.menu,
                          color: Colors.green,
                          size: 32,
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
                  const Text(
                    "Your playlists",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),
                  BlocBuilder<ApiBloc, ApiState>(
                    builder: (context, state) {
                      return state is ApiLoadedState
                          ? MyPlaylistsCarousel(api: state.api)
                          : const CircularProgressIndicator();
                    },
                  ),
                  const SizedBox(height: 25),
                  const Text(
                    "Recent tracks",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),
                  BlocBuilder<ApiBloc, ApiState>(
                    builder: (context, state) {
                      return state is ApiLoadedState
                          ? RecentTracksList(api: state.api)
                          : const CircularProgressIndicator();
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
