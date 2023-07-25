import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:spotify/spotify.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final SpotifyApi api;
  HomeCubit({required this.api}) : super(HomeState());

  Future<void> getRecommendations() async {
    print('getRecommendations');

    final fav = await api.tracks.me.saved.getPage(10, Random().nextInt(15));
    final List<String> seedTracks = [];
    for (int i = 0; i < 3; i++) {
      seedTracks.add(
        fav.items!.elementAt(Random().nextInt(fav.items!.length)).track!.id!,
      );
    }

    final recommendations = await api.recommendations.get(
      seedTracks: seedTracks,
      seedArtists: (await api.me.topArtists()).map((e) => e.id!).take(2),
      seedGenres: [],
      limit: 20,
    );
    emit(state.copyWith(recommendations: recommendations));
  }

  Future<void> getMyPlaylists() async {
    print("getMyPlaylists");

    final result = await api.playlists.me.all();
    emit(state.copyWith(myPlaylists: result));
  }

  Future<void> getRecentTracks() async {
    print("getRecentTracks");

    final result = await api.me.recentlyPlayed().all();
    emit(state.copyWith(recentTracks: result));
  }
}
