import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/spotify.dart' hide Image;
import 'package:spotify_remake/core/bloc/bloc_exports.dart';

class PlaylistPage extends StatelessWidget {
  final PlaylistSimple playlist;
  const PlaylistPage({super.key, required this.playlist});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocBuilder<PlaylistCubit, PlaylistState>(
        builder: (context, state) {
          if (state is PlaylistLoadedState) {
            final playlist = state.playlist;

            print(playlist.owner!.images!.first.url!);

            return PlaylistHeader(playlist: playlist);
          } else if (state is PlaylistLoadingState) {
            return PlaylistHeader(playlist: state.playlist);
          } else {
            context.read<PlaylistCubit>().getPlaylist(playlist);

            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}

class PlaylistHeader extends StatelessWidget {
  final PlaylistSimple playlist;
  const PlaylistHeader({super.key, required this.playlist});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: MediaQuery.of(context).padding.top),
        Hero(
          tag: playlist.id!,
          child: Image.network(
            playlist.images!.first.url!,
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                playlist.name!,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              Text(
                playlist.description ?? '',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Text(playlist.owner?.email ?? 'nonono'),
                  Text(playlist.owner!.displayName!),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
