import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/spotify.dart' hide Image;
import 'package:spotify_remake/core/bloc/bloc_exports.dart';
import 'package:spotify_remake/pages/playlist/playlist_page.dart';

class PlaylistTile extends StatelessWidget {
  final PlaylistSimple playlist;
  const PlaylistTile(this.playlist, {super.key});

  @override
  Widget build(BuildContext context) {
    final api = context.read<ApiBloc>().state.api!;
    final imageCache = context.read<ImageCacheCubit>();

    return GestureDetector(
      onTap: () {
        final route = MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => PlaylistCubit(
                  api: api,
                  playlist: playlist,
                )..load(),
              ),
              BlocProvider.value(value: imageCache)
            ],
            child: const PlaylistPage(),
          ),
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
