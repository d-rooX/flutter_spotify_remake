import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_remake/core/bloc/bloc_exports.dart';

class TopArtistsList extends StatelessWidget {
  const TopArtistsList({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          final topArtists = state.topArtists;

          if (topArtists == null) {
            context.read<HomeCubit>().getTopArtists();

            return const CircularProgressIndicator();
          }

          return ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: topArtists.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final artist = topArtists.elementAt(index);

              return Image.network(artist.images!.first.url!);
            },
          );
        },
      ),
    );
  }
}
