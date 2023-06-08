import 'package:flutter/material.dart';
import 'package:spotify_remake/core/models/audio_track.dart';
import 'package:spotify_remake/pages/home/home_page.dart';
import 'package:spotify_remake/pages/player/player_page.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryTextTheme: Typography.whiteCupertino,
        textTheme: Typography.whiteCupertino,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      home: HomePage(),
    );
  }
}

class TrackPageLoader extends StatefulWidget {
  const TrackPageLoader({Key? key}) : super(key: key);

  @override
  State<TrackPageLoader> createState() => _TrackPageLoaderState();
}

class _TrackPageLoaderState extends State<TrackPageLoader> {
  late Future<AudioTrack> _future;

  @override
  void initState() {
    _future = AudioTrack.fromAsset('kino_night.mp3');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _future,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? PlayerPage(track: snapshot.data!)
            : Container(
                alignment: Alignment.center,
                child: const CircularProgressIndicator(),
              );
      },
    );
  }
}
