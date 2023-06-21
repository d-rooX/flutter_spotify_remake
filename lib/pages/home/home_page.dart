import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:spotify_remake/pages/home/widgets/my_playlists_carousel.dart';
import 'package:spotify_remake/pages/home/widgets/recent_tracks_dropdown.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: DecoratedBox(
        decoration: BoxDecoration(color: Colors.black),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Ionicons.search, size: 32),
                    Icon(Ionicons.menu, size: 32)
                  ],
                ),
              ),
              SizedBox(height: 25),
              Text(
                "Your playlists",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 15),
              MyPlaylistsCarousel(),
              SizedBox(height: 25),
              Text(
                "Recent tracks",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 15),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: RecentTracksDropdown(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
