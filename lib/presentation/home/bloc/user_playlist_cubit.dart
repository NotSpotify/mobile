import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notspotify/domain/entities/playlist/playlist.dart';
import 'package:notspotify/domain/usecases/user/fetch_playlist.dart';
import 'package:notspotify/service_locator.dart';

class UserPlaylistCubit extends Cubit<List<PlaylistEntity>> {
  UserPlaylistCubit() : super([]);

  Future<void> fetchUserPlaylists() async {
    final result = await sl<FetchPlaylistUseCase>().call();

    result.fold(
      (error) {
        emit([]);
      },
      (playlists) {
        emit(List<PlaylistEntity>.from(playlists));
      },
    );
  }
}
