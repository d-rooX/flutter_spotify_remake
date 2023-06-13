import 'package:flutter/material.dart';
import 'package:spotify/spotify.dart' hide Image;
import 'package:spotify/spotify.dart' as spotapi;
import 'package:spotify_remake/core/utils/future_builder_wrapper.dart';

class TrackTile extends StatefulWidget {
  final TrackSimple track;
  final SpotifyApi api;

  const TrackTile({super.key, required this.track, required this.api});

  @override
  State<TrackTile> createState() => _TrackTileState();
}

class _TrackTileState extends State<TrackTile> {
  spotapi.Image? cover;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.green.withAlpha(80),
        borderRadius: BorderRadius.circular(5),
      ),
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          FutureBuilderWrapper(
            future: getCover(),
            onLoading: (context) => const SizedBox(
              height: 50,
              width: 50,
              child: CircularProgressIndicator(),
            ),
            onDone: (context, image) => GestureDetector(
              onTap: showFullscreenCover,
              child: Hero(
                tag: "image_${widget.track.id}",
                child: Image.network(
                  image.url!,
                  height: 50,
                  width: 50,
                ),
              ),
            ),
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: getFormattedArtists(),
                softWrap: false,
                overflow: TextOverflow.fade,
              ),
              Text(
                widget.track.name ?? '',
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  void showFullscreenCover() {
    final route = MaterialPageRoute(
      builder: (context) => GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Hero(
          tag: "image_${widget.track.id}",
          child: Image.network(
            cover?.url ?? '',
            height: 250,
            width: 250,
          ),
        ),
      ),
    );
    Navigator.of(context).push(route);
  }

  Future<spotapi.Image> getCover() async {
    final _cover =
        (await widget.api.tracks.get(widget.track.id!)).album!.images!.first;
    cover = _cover;
    return _cover;
  }

  TextSpan getFormattedArtists() {
    final artists = widget.track.artists!;

    return TextSpan(
      text: artists.first.name,
      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
      children: [
        if (artists.length > 1)
          TextSpan(
            text: ", ${artists[1].name}",
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 13,
              fontWeight: FontWeight.normal,
            ),
          ),
      ],
    );
  }
}
