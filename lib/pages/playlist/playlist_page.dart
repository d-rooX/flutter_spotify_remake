import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/spotify.dart' hide Image;
import 'package:spotify_remake/core/bloc/bloc_exports.dart';

import '../home/widgets/track_list.dart';

const double avatarRadius = 20;

class PlaylistPage extends StatelessWidget {
  const PlaylistPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocBuilder<PlaylistCubit, PlaylistState>(
        builder: (context, state) {
          final playlist = state.playlist;
          List<UserPublic>? authors;
          List<PlaylistTrack>? tracks;

          if (state is PlaylistLoadedState) {
            tracks = state.tracks;
            authors = state.authors;
          }

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
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
                      if (playlist.description != null &&
                          playlist.description != '') ...[
                        Text(
                          playlist.description!,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 15),
                      ],
                      Row(
                        children: [
                          if (authors != null &&
                              authors.first.images!.isNotEmpty)
                            CircleAvatar(
                              radius: avatarRadius,
                              foregroundImage: Image.network(
                                authors.first.images!.first.url!,
                              ).image,
                            )
                          else
                            const CircleAvatar(
                              radius: avatarRadius,
                              backgroundColor: Colors.grey,
                            ),
                          const SizedBox(width: 10),
                          Text(
                            playlist.owner!.displayName!,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (tracks != null) ...[
                  const SizedBox(height: 20),
                  TrackList(
                    tracks:
                        tracks!.map((e) => e.track!).toList(growable: false),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
