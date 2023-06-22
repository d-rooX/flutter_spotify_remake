import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/spotify.dart' hide Image;
import 'package:spotify/spotify.dart' as spotapi;
import 'package:spotify_remake/core/bloc/bloc_exports.dart';

class TrackTile extends StatefulWidget {
  final TrackSimple track;
  const TrackTile({super.key, required this.track});

  @override
  State<TrackTile> createState() => _TrackTileState();
}

class _TrackTileState extends State<TrackTile> {
  Image? coverImage;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          BlocBuilder<ImageCacheCubit, ImageCacheState>(
            buildWhen: (previous, current) =>
                current.cache.containsKey(widget.track.id!),
            builder: (context, state) {
              final imageCacheCubit = context.read<ImageCacheCubit>();
              final cache = state.cache;
              final spotapi.Image? cover = cache[widget.track.id!];

              if (cover == null) {
                imageCacheCubit.getCover(widget.track);

                return Container(
                  height: 50,
                  width: 50,
                  color: Colors.white24,
                );
              }
              coverImage ??= Image.network(
                cover.url!,
                height: 50,
                width: 50,
              );

              return GestureDetector(
                onTap: showFullscreenCover,
                child: coverImage,
              );
            },
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  softWrap: false,
                  overflow: TextOverflow.fade,
                  widget.track.name ?? '',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                RichText(
                  text: getFormattedArtists(),
                  softWrap: false,
                  overflow: TextOverflow.fade,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void showFullscreenCover() {
    final route = MaterialPageRoute(
      builder: (context) => GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: coverImage,
      ),
    );
    Navigator.of(context).push(route);
  }

  TextSpan getFormattedArtists() {
    final artists = widget.track.artists!;

    return TextSpan(
      text: artists.first.name,
      style: const TextStyle(fontSize: 13, color: Colors.white60),
      children: [
        if (artists.length > 1)
          TextSpan(
            text: ", ${artists[1].name}",
            style: const TextStyle(
              color: Colors.white38,
              fontSize: 13,
              fontWeight: FontWeight.normal,
            ),
          ),
      ],
    );
  }
}
