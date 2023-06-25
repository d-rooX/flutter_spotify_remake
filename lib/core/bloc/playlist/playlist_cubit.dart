import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:spotify/spotify.dart';

part 'playlist_state.dart';

class PlaylistCubit extends Cubit<PlaylistState> {
  final SpotifyApi api;
  PlaylistCubit({required this.api}) : super(const PlaylistInitial());

  Future<void> getPlaylist(PlaylistSimple playlist) async {
    emit(PlaylistLoadingState(playlist));
    final playlistFull = await api.playlists.get(playlist.id!);
    emit(PlaylistLoadedState(playlist: playlistFull));
  }
}
