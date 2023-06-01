import 'dart:ui';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:spotify_remake/core/models/audio_track.dart';

///
class PlayerControls extends StatefulWidget {
  final AudioTrack track;
  final Color mainColor;

  ///
  const PlayerControls({
    Key? key,
    required this.track,
    required this.mainColor,
  }) : super(key: key);

  @override
  State<PlayerControls> createState() => _PlayerControlsState();
}

class _PlayerControlsState extends State<PlayerControls> {
  late Future<PlayerController> _getPlayerFuture;

  @override
  void initState() {
    _getPlayerFuture = getPlayerController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
        child: Container(
          height: 220,
          color: const Color.fromRGBO(30, 30, 30, 0.5),
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
          child: FutureBuilder(
            future: _getPlayerFuture,
            builder: (context, snapshot) {
              return snapshot.hasData
                  ? PlayerControlsBar(
                      track: widget.track,
                      playerController: snapshot.data!,
                      mainColor: widget.mainColor,
                    )
                  : const CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }

  Future<PlayerController> getPlayerController() async {
    final playerController = PlayerController();
    await playerController.preparePlayer(
      path: widget.track.filepath,
      volume: 1.0,
      noOfSamples: 300,
    );
    playerController.updateFrequency = UpdateFrequency.medium;

    return playerController;
  }
}

///
class ControlButton extends StatefulWidget {
  final IconData icon;
  final double size;
  final GestureTapCallback onTap;

  ///
  const ControlButton({
    Key? key,
    required this.icon,
    required this.size,
    required this.onTap,
  }) : super(key: key);

  @override
  State<ControlButton> createState() => _ControlButtonState();
}

class _ControlButtonState extends State<ControlButton> {
  bool isTapped = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) => setState(() => isTapped = true),
      onTap: widget.onTap,
      onTapUp: (details) => setState(() => isTapped = false),
      child: AnimatedContainer(
        width: widget.size + 5,
        height: widget.size + 5,
        duration: const Duration(milliseconds: 75),
        curve: Curves.easeInOut,
        padding: EdgeInsets.all(isTapped ? 0 : 5),
        child: FittedBox(
          fit: BoxFit.fitWidth,
          child: Icon(widget.icon, size: widget.size),
        ),
      ),
    );
  }
}

class PlayerControlsBar extends StatefulWidget {
  final AudioTrack track;
  final PlayerController playerController;
  final Color mainColor;

  const PlayerControlsBar({
    Key? key,
    required this.track,
    required this.playerController,
    required this.mainColor,
  }) : super(key: key);

  @override
  State<PlayerControlsBar> createState() => _PlayerControlsBarState();
}

class _PlayerControlsBarState extends State<PlayerControlsBar> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.track.tags?.title ?? '<unknown>',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              widget.track.tags?.artist ?? '<unknown artist>',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[400],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            const Icon(Ionicons.shuffle, size: 27),
            const Spacer(),
            ControlButton(
              icon: Ionicons.play_skip_back,
              size: 40,
              onTap: () => widget.playerController.seekTo(0),
            ),
            const SizedBox(width: 15),
            ControlButton(
              icon: widget.playerController.playerState == PlayerState.playing
                  ? Ionicons.pause_circle
                  : Ionicons.play_circle,
              size: 50,
              onTap: () => setState(
                () {
                  if (widget.playerController.playerState ==
                      PlayerState.paused) {
                    widget.playerController.startPlayer();
                  } else {
                    widget.playerController.pausePlayer();
                  }
                },
              ),
            ),
            const SizedBox(width: 15),
            ControlButton(
              icon: Ionicons.play_skip_forward,
              size: 40,
              onTap: () {},
            ),
            const Spacer(),
            const Icon(Ionicons.repeat, size: 27)
          ],
        ),
        const SizedBox(height: 15),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: DecoratedBox(
              decoration: const BoxDecoration(
                color: Color.fromRGBO(150, 150, 150, 0.4),
              ),
              child: AudioFileWaveforms(
                size: Size(
                  MediaQuery.of(context).size.width,
                  MediaQuery.of(context).size.height,
                ),
                playerController: widget.playerController,
                waveformType: WaveformType.long,
                animationDuration: const Duration(milliseconds: 1000),
                playerWaveStyle: PlayerWaveStyle(
                  backgroundColor: Colors.transparent,
                  liveWaveColor: HSLColor.fromColor(widget.mainColor)
                      .withLightness(0.3)
                      .toColor(),
                  seekLineThickness: 1.5,
                  seekLineColor: Colors.grey.shade500,
                  spacing: 4,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
