import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notspotify/domain/usecases/song/get_random_song.dart';
import 'package:notspotify/domain/usecases/song/recommend_song.dart';
import 'package:notspotify/presentation/home/bloc/songs_state.dart';
import 'package:notspotify/service_locator.dart';

class SongCubit extends Cubit<RandomSongState> {
  SongCubit() : super(RandomSongLoading());

  Future<void> getRandomSong() async {
    emit(RandomSongLoading());
    final result = await sl<GetRandomSongUseCase>().call();
    result.fold(
      (error) => emit(RandomSongError(error)),
      (songs) => emit(RandomSongLoaded(songs)),
    );
  }

  Future<void> recommend() async {
    emit(RandomSongLoading());
    final result = await sl<RecommendSongUseCase>().call();
    result.fold(
      (error) => emit(RandomSongError(error)),
      (suggestSongs) => emit(RandomSongLoaded(suggestSongs)),
    );
  }
}
