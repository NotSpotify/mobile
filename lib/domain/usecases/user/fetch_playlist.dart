import 'package:dartz/dartz.dart';
import 'package:notspotify/core/usecase/usecase.dart';
import 'package:notspotify/domain/repository/user/user_repo.dart';
import 'package:notspotify/service_locator.dart';

class FetchPlaylistUseCase implements UseCase<Either, dynamic> {
  @override
  Future<Either> call({params}) async {
    return await sl<UserRepository>().fetchPlaylistsFromFirestore();
  }
}
