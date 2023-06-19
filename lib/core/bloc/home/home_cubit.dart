import 'package:bloc/bloc.dart';
import 'package:spotify/spotify.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final SpotifyApi api;
  HomeCubit({required this.api}) : super(HomeState());

  Future<void> getTopArtists() async {
    final Iterable<Artist> result = await api.me.topArtists();
    emit(state.copyWith(topArtists: result));
  }

  Future<void> getMyPlaylists() async {
    final result = await api.playlists.me.all();
    emit(state.copyWith(myPlaylists: result));
  }

  Future<void> getRecentTracks() async {
    final result = await api.me.recentlyPlayed().all();
    emit(state.copyWith(recentTracks: result));
  }
}
