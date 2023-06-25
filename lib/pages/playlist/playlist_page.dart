import 'package:flutter/material.dart';
import 'package:spotify/spotify.dart' hide Image;

class PlaylistPage extends StatelessWidget {
  final PlaylistSimple playlist;
  const PlaylistPage({super.key, required this.playlist});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).padding.top),
          Hero(
            tag: playlist.id!,
            child: Image.network(
              playlist.images!.first.url!,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            playlist.name!,
            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Text(
            playlist.description!,
            style: const TextStyle(fontSize: 22),
          ),
        ],
      ),
    );
  }
}
