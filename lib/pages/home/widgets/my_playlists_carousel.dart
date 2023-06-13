import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:spotify/spotify.dart';
import 'package:spotify_remake/core/utils/future_builder_wrapper.dart';

import 'playlist_tile.dart';

class MyPlaylistsCarousel extends StatefulWidget {
  final SpotifyApi api;
  const MyPlaylistsCarousel({super.key, required this.api});

  @override
  State<MyPlaylistsCarousel> createState() => _MyPlaylistsCarouselState();
}

class _MyPlaylistsCarouselState extends State<MyPlaylistsCarousel> {
  final CarouselController _controller = CarouselControllerImpl();
  final CarouselOptions options = CarouselOptions(
    viewportFraction: 0.65,
    enableInfiniteScroll: false,
    height: 250,
    enlargeCenterPage: true,
    enlargeStrategy: CenterPageEnlargeStrategy.zoom,
    enlargeFactor: 0.6,
    scrollPhysics: const BouncingScrollPhysics(),
  );
  Future<Iterable<PlaylistSimple>>? _request;

  @override
  void initState() {
    _request = widget.api.playlists.me.all();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilderWrapper(
      future: _request!,
      onLoading: (context) => CarouselSlider(
        items: const [
          Placeholder(),
          Placeholder(),
          Placeholder(),
          Placeholder(),
        ],
        options: options,
      ),
      onDone: (context, data) => CarouselSlider(
        carouselController: _controller,
        items: data
            .map((playlist) => PlaylistTile(playlist))
            .toList(growable: false),
        options: options,
      ),
    );
  }
}
