import 'package:dartz/dartz.dart';
import 'package:notspotify/core/usecase/usecase.dart';
import 'package:notspotify/domain/repository/auth/auth_repo.dart';
import 'package:notspotify/service_locator.dart';

class UpdateGenreUseCase implements UseCase<Either, List<dynamic>> {
  @override
  Future<Either> call({List<dynamic>? params}) {
    final String userId = params![0] as String;
    final List<String> genres = params[1] as List<String>;
    return sl<AuthRepo>().updateGerne(userId, genres);
  }
}
