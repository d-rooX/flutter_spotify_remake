import 'dart:io';

import 'package:audiotagger/audiotagger.dart';
import 'package:audiotagger/models/tag.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class AudioTrack {
  final String filepath;
  final Uint8List? artwork;
  final Tag? tags;

  /// Constructor
  const AudioTrack({
    required this.filepath,
    required this.artwork,
    required this.tags,
  });

  static Future<AudioTrack> fromAsset(String filename) async {
    final file = await _loadFromAsset(filename);

    return fromFile(file.path);
  }

  static Future<AudioTrack> fromFile(String filepath) async {
    final tagger = Audiotagger();
    final Tag? tags = await tagger.readTags(path: filepath);

    if (tags != null) {
      if (tags.title?.isEmpty ?? true) {
        tags.title = null;
      }

      if (tags.artist?.isEmpty ?? true) {
        tags.artist = null;
      }
    }
    final artwork = await tagger.readArtwork(path: filepath);

    return AudioTrack(filepath: filepath, artwork: artwork, tags: tags);
  }

  static Future<File> _loadFromAsset(String assetFilename) async {
    final Directory dir = await getApplicationDocumentsDirectory();
    final loadTo = "${dir.path}/$assetFilename";

    final File file = File(loadTo);
    if (await file.exists() && (await file.length()) > 0) return file;

    await file.create();
    final data = await rootBundle.load('lib/assets/audio/$assetFilename');
    await file.writeAsBytes(data.buffer.asUint8List());

    return file;
  }
}
