import 'package:bloc/bloc.dart';
import 'package:spotify/spotify.dart';

part 'image_cache_state.dart';

class ImageCacheCubit extends Cubit<ImageCacheState> {
  final SpotifyApi api;
  ImageCacheCubit({required this.api}) : super(ImageCacheState());

  Future<void> getCover(TrackSimple track) async {
    final fullTrack = await api.tracks.get(track.id!);
    final cover = fullTrack.album?.images?.first;
    if (cover != null) {
      final newCache = {
        ...state.cache,
        track.id!: cover,
      };
      emit(
        ImageCacheState(
          cache: newCache,
        ),
      );
    }
  }
}
