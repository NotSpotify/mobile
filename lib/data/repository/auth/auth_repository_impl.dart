import 'package:dartz/dartz.dart';
import 'package:notspotify/data/models/auth/create_user_req.dart';
import 'package:notspotify/data/models/auth/signin_user_req.dart';
import 'package:notspotify/data/sources/auth/auth_firebase_service.dart';
import 'package:notspotify/domain/repository/auth/auth_repo.dart';
import 'package:notspotify/service_locator.dart';

class AuthRepositoryImpl extends AuthRepo {
  @override
  Future<Either> signInWithApple() {
    throw UnimplementedError();
  }

  @override
  Future<Either> signInWithEmailAndPassword(SigninUserReq signinUserReq) async {
    return await sl<AuthFirebaseService>().signInWithEmailAndPassword(
      signinUserReq,
    );
  }

  @override
  Future<Either> signUpWithEmailAndPassword(CreateUserReq createUserReq) async {
    return await sl<AuthFirebaseService>().signUpWithEmailAndPassword(
      createUserReq,
    );
  }

   @override
  Future<Either> getUser() {
    return sl<AuthFirebaseService>().getUser();
  }

  @override
  Future<Either> signInWithGoogle() {
    return sl<AuthFirebaseService>().signInWithGoogle();
  }

  @override
  Future<Either> signOut() {
    throw UnimplementedError();
  }
  
 

  
  
}