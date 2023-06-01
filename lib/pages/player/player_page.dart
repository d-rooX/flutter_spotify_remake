import 'package:flutter/material.dart';
import 'package:spotify_remake/core/image_analyzer.dart';
import 'package:spotify_remake/core/models/audio_track.dart';
import 'package:spotify_remake/pages/player/widgets/player_widgets.dart';

class PlayerPage extends StatefulWidget {
  final AudioTrack track;

  const PlayerPage({Key? key, required this.track}) : super(key: key);

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  Color mainBackgroundColor = const Color.fromRGBO(145, 175, 128, 1.0);

  LinearGradient get backgroundGradient => LinearGradient(
        colors: [
          mainBackgroundColor,
          HSLColor.fromColor(mainBackgroundColor).withSaturation(0.8).toColor(),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  @override
  void initState() {
    _getBackground().then(
      (value) => setState(() => mainBackgroundColor = value),
    );
    super.initState();
  }

  Future<Color> _getBackground() async {
    Color resColor = mainBackgroundColor;
    if (widget.track.artwork != null) {
      resColor = await ImageAnalyzer.getImagePalette(
            MemoryImage(widget.track.artwork!),
          ) ??
          mainBackgroundColor;
    }

    return resColor;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 800),
      decoration: BoxDecoration(gradient: backgroundGradient),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            alignment: Alignment.topCenter,
            children: [
              const Positioned(
                top: 0,
                right: 0,
                left: 0,
                child: PlayerTopBar(),
              ),
              Positioned(
                top: 80,
                left: 0,
                right: 0,
                child: PlayerTrackCard(
                  track: widget.track,
                  mainColor: mainBackgroundColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
