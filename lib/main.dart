import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ionicons/ionicons.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primaryTextTheme: Typography.whiteCupertino,
      textTheme: Typography.whiteCupertino,
      iconTheme: const IconThemeData(color: Colors.white),
    ),
    home: const PlayerPage(),
  ));
}

class PlayerPage extends StatelessWidget {
  const PlayerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var background = const LinearGradient(
      colors: [Colors.blue, Colors.lightBlueAccent],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    return Container(
      decoration: BoxDecoration(gradient: background),
      child: const SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            alignment: Alignment.topCenter,
            children: [
              Positioned(top: 0, right: 0, left: 0, child: PlayerTopBar()),
              Positioned(
                top: 80,
                left: 0,
                right: 0,
                child: TrackCard(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PlayerTopBar extends StatelessWidget {
  const PlayerTopBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Playing from playlist",
                style: TextStyle(fontSize: 12),
              ),
              Text(
                "Best of Nirvana",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
          Icon(Icons.more_vert)
        ],
      ),
    );
  }
}

class TrackCard extends StatelessWidget {
  const TrackCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Image.asset('lib/pictures/cover.jpg'),
          const PlayerCardActions(),
          const Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: PlayerControls(),
          )
        ],
      ),
    );
  }
}

class PlayerCardActions extends StatelessWidget {
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

class PlayerControls extends StatefulWidget {
  const PlayerControls({Key? key}) : super(key: key);

  @override
  State<PlayerControls> createState() => _PlayerControlsState();
}

class _PlayerControlsState extends State<PlayerControls> {
  final PlayerController playerController = PlayerController();

  Future getPlayerController(String filename) async {
    Directory dir = await getApplicationDocumentsDirectory();
    String filepath = '${dir.path}/$filename';

    File file = File(filepath);
    if (!(await file.exists())) {
      await file.create();
      ByteData data = await rootBundle.load('lib/audio/$filename');
      await file.writeAsBytes(
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
      );
    }

    playerController.preparePlayer(
      path: file.path,
      volume: 1.0,
      noOfSamples: 300,
    );
    playerController.updateFrequency = UpdateFrequency.medium;
    playerController.onPlayerStateChanged.listen((state) {
      log(state.toString());
    }, onError: (error) => log(error.toString()));
    playerController.onCurrentDurationChanged.listen((duration) {
      log("Duration: ${duration.toString()}");
    });
    playerController.onExtractionProgress.listen((progress) {
      log("Extraction progress: ${progress.toString()}");
    });
  }

  @override
  void initState() {
    getPlayerController("rape_me.mp3");
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Rape Me",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    "Nirvana",
                    style: TextStyle(fontSize: 16, color: Colors.grey[400]),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Icon(Ionicons.shuffle, size: 27),
                  Spacer(),
                  Icon(Ionicons.play_skip_back, size: 35),
                  SizedBox(width: 20),
                  GestureDetector(
                    onTap: () async {
                      if (playerController.playerState == PlayerState.paused) {
                        await playerController.startPlayer();
                      } else {
                        await playerController.pausePlayer();
                      }
                      setState(() {});
                    },
                    child: Icon(
                        playerController.playerState == PlayerState.playing
                            ? Ionicons.pause_circle
                            : Ionicons.play_circle,
                        size: 45),
                  ),
                  SizedBox(width: 20),
                  Icon(Ionicons.play_skip_forward, size: 35),
                  Spacer(),
                  Icon(Ionicons.repeat, size: 27)
                ],
              ),
              const SizedBox(height: 15),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color.fromRGBO(150, 150, 150, 0.4),
                    ),
                    child: AudioFileWaveforms(
                      size: Size(
                        MediaQuery.of(context).size.width,
                        MediaQuery.of(context).size.height - 50,
                      ),
                      playerController: playerController,
                      waveformType: WaveformType.long,
                      animationDuration: const Duration(milliseconds: 1000),
                      playerWaveStyle: PlayerWaveStyle(
                        backgroundColor: Colors.transparent,
                        liveWaveColor: Colors.lightBlueAccent,
                        seekLineThickness: 1.5,
                        seekLineColor: Colors.grey[500]!,
                        spacing: 4,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
