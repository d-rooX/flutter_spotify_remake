import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/spotify.dart' as spotapi;
import 'package:spotify_remake/core/bloc/bloc_exports.dart';

class CoversSlider extends StatelessWidget {
  final Iterable<spotapi.TrackSimple> tracks;
  const CoversSlider({super.key, required this.tracks});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      separatorBuilder: (context, index) => const SizedBox(width: 10),
      itemBuilder: (context, index) {
        if (index == 0 || index == tracks.length - 1) {
          return SizedBox(width: 15);
        }
        final track = tracks!.elementAt(index)!;

        return BlocBuilder<ImageCacheCubit, ImageCacheState>(
          buildWhen: (previous, current) =>
              current.cache.containsKey(track.id!),
          builder: (context, state) {
            final cover = state.cache[track.id];
            if (cover == null) {
              context.read<ImageCacheCubit>().getCover(track);

              return const ColoredBox(color: Colors.grey);
            } else {
              return Image.network(cover.url!);
            }
          },
        );
      },
      itemCount: tracks.length,
    );
  }
}
