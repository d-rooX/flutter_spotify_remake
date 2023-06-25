import 'package:flutter/material.dart';
import 'package:spotify/spotify.dart' hide Image;
import 'package:spotify_remake/pages/playlist/playlist_page.dart';

class PlaylistTile extends StatelessWidget {
  final PlaylistSimple playlist;
  const PlaylistTile(this.playlist, {super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final route = MaterialPageRoute(
          builder: (context) => PlaylistPage(playlist: playlist),
        );
        Navigator.of(context).push(route);
      },
      child: SizedBox(
        height: 250,
        width: 250,
        child: Hero(
          tag: playlist.id!,
          child: Image.network(
            playlist.images!.first.url!,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
