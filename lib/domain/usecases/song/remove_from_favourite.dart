import 'package:dartz/dartz.dart';
import 'package:notspotify/core/usecase/usecase.dart';
import 'package:notspotify/domain/repository/song/song_repo.dart';
import 'package:notspotify/service_locator.dart';

class RemoveFromFavouriteUseCase implements UseCase<Either, dynamic> {
  @override
  Future<Either> call({params}) async {
    return await sl<SongRepo>().removeSongFromFavourite(params['song']);
  }
}
