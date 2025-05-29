import 'package:dartz/dartz.dart';
import 'package:notspotify/core/usecase/usecase.dart';
import 'package:notspotify/domain/repository/user/user_repo.dart';
import 'package:notspotify/service_locator.dart';

class UploadGeneratePlaylistsUseCase
    implements UseCase<Either, List<String>> {
  @override
  Future<Either> call({
    List<String>? params,
  }) async {
    return await sl<UserRepository>().uploadGeneratePlaylists(params ?? []);
  }
}
