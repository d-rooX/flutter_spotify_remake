part of 'home_cubit.dart';

class HomeState {
  final Iterable<Artist>? topArtists;
  final Iterable<PlaylistSimple>? myPlaylists;
  final Iterable<PlayHistory>? recentTracks;

  const HomeState({this.topArtists, this.myPlaylists, this.recentTracks});

  HomeState copyWith({
    Iterable<Artist>? topArtists,
    Iterable<PlaylistSimple>? myPlaylists,
    Iterable<PlayHistory>? recentTracks,
  }) {
    return HomeState(
      topArtists: topArtists ?? this.topArtists,
      myPlaylists: myPlaylists ?? this.myPlaylists,
      recentTracks: recentTracks ?? this.recentTracks,
    );
  }
}
