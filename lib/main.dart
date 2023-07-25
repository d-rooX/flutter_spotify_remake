import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spotify_remake/app.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.black,
    ),
  );

  runApp(const App());
}
