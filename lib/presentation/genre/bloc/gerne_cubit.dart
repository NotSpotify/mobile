import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:notspotify/domain/usecases/auth/update_genre_usecase.dart';
import 'package:notspotify/service_locator.dart';

class GenreSelectionCubit extends Cubit<Set<String>> {
  GenreSelectionCubit() : super({});

  void toggleGenre(String genre) {
    final newSet = {...state};
    newSet.contains(genre) ? newSet.remove(genre) : newSet.add(genre);
    emit(newSet);
  }

  Future<Either> save(String userId, List<String> genres) {
    return sl<UpdateGenreUseCase>().call(params: [userId, genres]);
  }
}
