part of 'playlist_cubit.dart';

@immutable
abstract class PlaylistState {
  const PlaylistState();
}

class PlaylistInitial extends PlaylistState {
  const PlaylistInitial();
}

class PlaylistLoadingState extends PlaylistState {
  final PlaylistSimple playlist;
  const PlaylistLoadingState(this.playlist);
}

class PlaylistLoadedState extends PlaylistState {
  final Playlist playlist;

  const PlaylistLoadedState({required this.playlist});
}
