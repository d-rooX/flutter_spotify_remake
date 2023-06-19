import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_remake/core/bloc/home/home_cubit.dart';

import 'playlist_tile.dart';

class MyPlaylistsCarousel extends StatefulWidget {
  const MyPlaylistsCarousel({super.key});

  @override
  State<MyPlaylistsCarousel> createState() => _MyPlaylistsCarouselState();
}

class _MyPlaylistsCarouselState extends State<MyPlaylistsCarousel> {
  final CarouselController _controller = CarouselControllerImpl();
  final CarouselOptions options = CarouselOptions(
    viewportFraction: 0.7,
    enableInfiniteScroll: false,
    height: 250,
    enlargeCenterPage: true,
    enlargeStrategy: CenterPageEnlargeStrategy.zoom,
    enlargeFactor: 0.6,
    scrollPhysics: const BouncingScrollPhysics(),
  );

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        final data = state.myPlaylists;

        if (data == null) {
          final homeCubit = context.read<HomeCubit>();
          homeCubit.getMyPlaylists();

          return CarouselSlider(
            items: const [
              Placeholder(),
              Placeholder(),
              Placeholder(),
              Placeholder(),
            ],
            options: options,
          );
        } else {
          return CarouselSlider(
            carouselController: _controller,
            items: data
                .map((playlist) => PlaylistTile(playlist))
                .toList(growable: false),
            options: options,
          );
        }
      },
    );
  }
}
