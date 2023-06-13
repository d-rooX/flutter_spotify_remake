import 'package:flutter/material.dart';
import 'package:spotify/spotify.dart' hide Image;

class PlaylistTile extends StatelessWidget {
  final PlaylistSimple playlist;
  const PlaylistTile(this.playlist, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      width: 250,
      child: Image.network(
        playlist.images!.first.url!,
        fit: BoxFit.cover,
      ),
    );
  }
}
