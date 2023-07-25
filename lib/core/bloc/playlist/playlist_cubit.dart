import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:spotify/spotify.dart';

part 'playlist_state.dart';

class PlaylistCubit extends Cubit<PlaylistState> {
  final SpotifyApi api;
  final PlaylistSimple playlist;

  ///
  PlaylistCubit({
    required this.api,
    required this.playlist,
  }) : super(PlaylistInitial(playlist: playlist));

  Future<void> load() async {
    final playlistFull = await api.playlists.get(playlist.id!);
    final List<PlaylistTrack> tracks = [];
    for (final el in playlistFull.tracks!.itemsNative!) {
      final track = PlaylistTrack.fromJson(el as Map<String, dynamic>);
      tracks.add(track);
    }
    final author = await api.users.get(playlistFull.owner!.id!);

    emit(
      PlaylistLoadedState(
        playlist: playlistFull,
        authors: [author],
        tracks: tracks,
      ),
    );
  }
}
