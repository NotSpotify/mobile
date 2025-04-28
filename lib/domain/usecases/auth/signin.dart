import 'package:dartz/dartz.dart';
import 'package:notspotify/core/usecase/usecase.dart';
import 'package:notspotify/data/models/auth/signin_user_req.dart';
import 'package:notspotify/domain/repository/auth/auth_repo.dart';
import 'package:notspotify/service_locator.dart';

class SigninUseCase implements UseCase<Either, SigninUserReq> {
  @override
  Future<Either> call({SigninUserReq? params}) async {
    return await sl<AuthRepo>().signInWithEmailAndPassword(params!);
  }
}
