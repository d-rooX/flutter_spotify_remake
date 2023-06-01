import 'package:flutter/material.dart';

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
