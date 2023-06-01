import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:spotify_remake/core/models/audio_track.dart';
import 'package:spotify_remake/pages/player/widgets/player_controls.dart';

///
class PlayerTrackCard extends StatelessWidget {
  final AudioTrack track;
  final Color mainColor;

  ///
  const PlayerTrackCard({
    Key? key,
    required this.track,
    required this.mainColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          if (track.artwork != null)
            Image.memory(
              track.artwork!,
              height: 650,
              fit: BoxFit.fitHeight,
            )
          else
            Image.asset(
              "lib/assets/pictures/placeholder.png",
              height: 650,
            ),
          const PlayerCardActions(),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: PlayerControls(
              track: track,
              mainColor: mainColor,
            ),
          )
        ],
      ),
    );
  }
}

///
class PlayerCardActions extends StatelessWidget {
  ///
  const PlayerCardActions({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
        child: Container(
          height: 70,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Icon(Icons.tv),
              Icon(Icons.playlist_add),
              Icon(Icons.share),
              Icon(Icons.favorite_border),
            ],
          ),
        ),
      ),
    );
  }
}
