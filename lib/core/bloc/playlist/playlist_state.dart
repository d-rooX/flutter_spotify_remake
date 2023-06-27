part of 'playlist_cubit.dart';

@immutable
abstract class PlaylistState {
  final PlaylistSimple playlist;
  const PlaylistState({required this.playlist});
}

class PlaylistInitial extends PlaylistState {
  const PlaylistInitial({required super.playlist});
}

class PlaylistLoadedState extends PlaylistState {
  final Playlist playlist;
  final List<PlaylistTrack> tracks;
  final List<UserPublic> authors;

  const PlaylistLoadedState({
    required this.playlist,
    required this.authors,
    required this.tracks,
  }) : super(playlist: playlist);
}
