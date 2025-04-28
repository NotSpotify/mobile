import 'package:dartz/dartz.dart';
import 'package:notspotify/core/usecase/usecase.dart';
import 'package:notspotify/domain/repository/auth/auth_repo.dart';
import 'package:notspotify/service_locator.dart';

class GetUserUseCase implements UseCase<Either, dynamic> {
  @override
  Future<Either> call({params}) {
    return sl<AuthRepo>().getUser();
  }
}
