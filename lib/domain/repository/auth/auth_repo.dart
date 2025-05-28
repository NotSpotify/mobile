import 'package:dartz/dartz.dart';
import 'package:notspotify/data/models/auth/create_user_req.dart';
import 'package:notspotify/data/models/auth/signin_user_req.dart';

abstract class AuthRepo {
  Future<Either> signInWithEmailAndPassword(SigninUserReq signinUserReq);
  Future<Either> signUpWithEmailAndPassword(CreateUserReq createUserReq);
  Future<Either> getUser();
  Future<Either> signInWithGoogle();
  Future<Either> signInWithApple();
  Future<Either> signOut();

  Future<Either> updateUserProfile(String fullName, String email);
  Future<Either> updateUserProfileImage(String imagePath);

  // Future<Either> resetPassword(String email);
  // Future<Either> verifyEmail(String email);
  // Future<Either> sendEmailVerification(String email);
  // Future<Either> updateUserPassword(String password);
  // Future<Either> updateUserEmail(String email);
  // Future<Either> deleteUserAccount();
  // Future<Either> deleteUserAccountWithPassword(String password);
  // Future<Either> deleteUserAccountWithEmail(String email);
}
