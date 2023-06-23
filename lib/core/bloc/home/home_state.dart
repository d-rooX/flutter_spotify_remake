part of 'home_cubit.dart';

class HomeState {
  final Recommendations? recommendations;
  final Iterable<PlaylistSimple>? myPlaylists;
  final Iterable<PlayHistory>? recentTracks;

  const HomeState({this.recommendations, this.myPlaylists, this.recentTracks});

  HomeState copyWith({
    Recommendations? recommendations,
    Iterable<PlaylistSimple>? myPlaylists,
    Iterable<PlayHistory>? recentTracks,
  }) {
    return HomeState(
      recommendations: recommendations ?? this.recommendations,
      myPlaylists: myPlaylists ?? this.myPlaylists,
      recentTracks: recentTracks ?? this.recentTracks,
    );
  }
}
