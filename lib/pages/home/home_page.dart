import 'package:flutter/material.dart';
import 'package:spotify_remake/pages/home/widgets/my_playlists_carousel.dart';
import 'package:spotify_remake/pages/home/widgets/recent_tracks_dropdown.dart';
import 'package:spotify_remake/pages/home/widgets/top_artists_list.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
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
                  Text(
                    "Good evening",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 23,
                    ),
                  ),
                  Spacer(),
                  Icon(Icons.notifications_none_rounded, size: 30),
                  SizedBox(width: 35),
                  Icon(Icons.settings, size: 30)
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
            ),
            SizedBox(height: 25),
            Text(
              "Top artists",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 15),
            TopArtistsList()
          ],
        ),
      ),
    );
  }
}
