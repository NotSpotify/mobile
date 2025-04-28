import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:notspotify/data/models/auth/create_user_req.dart';
import 'package:notspotify/data/models/auth/signin_user_req.dart';
import 'package:notspotify/data/models/auth/user.dart';
import 'package:notspotify/domain/entities/auth/user.dart';

abstract class AuthFirebaseService {
  Future<Either> signInWithEmailAndPassword(SigninUserReq signinUserReq);
  Future<Either> signUpWithEmailAndPassword(CreateUserReq createUserReq);
  Future<Either> signInWithGoogle();
  // Future<Either> signInWithApple();
  Future<Either> signOut();

  Future<Either> getUser();
  //   Future<Either> resetPassword(String email);
  //   Future<Either> verifyEmail(String email);
  //   Future<Either> sendEmailVerification(String email);
  //   Future<Either> updateUserProfile(String fullName, String email);
  //   Future<Either> updateUserPassword(String password);
  //   Future<Either> updateUserEmail(String email);
  //   Future<Either> updateUserProfileImage(String imagePath);
  //   Future<Either> deleteUserAccount();
  //   Future<Either> deleteUserAccountWithPassword(String password);
  //   Future<Either> deleteUserAccountWithEmail(String email);
}

class AuthSupabaseServiceImpl implements AuthFirebaseService {
  @override
  Future<Either> signUpWithEmailAndPassword(CreateUserReq createUserReq) async {
    try {
      var data = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: createUserReq.email,
        password: createUserReq.password,
      );

      FirebaseFirestore.instance.collection('users').doc(data.user!.uid).set({
        'full_name': createUserReq.fullName,
        'email': createUserReq.email,
      });

      return const Right('Signin was Successful');
    } on FirebaseAuthException catch (e) {
      String message = '';

      if (e.code == 'weak-password') {
        message = 'The password provided is too weak';
      } else if (e.code == 'email-already-in-use') {
        message = 'An account already exists with that email.';
      }

      return Left(message);
    }
  }

  @override
  Future<Either> signInWithEmailAndPassword(SigninUserReq signinUserReq) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: signinUserReq.email,
        password: signinUserReq.password,
      );

      return Right('Signin was Successful');
    } on FirebaseAuthException catch (e) {
      String message = '';

      if (e.code == 'invalid-email') {
        message = 'Not user found for that email';
      } else if (e.code == 'invalid-credential') {
        message = 'Wrong password provided for that user';
      }

      return Left(message);
    }
  }

  @override
  // Future<Either> signInWithApple() {}
  @override
  Future<Either> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    final UserCredential userCredential = await FirebaseAuth.instance
        .signInWithCredential(credential);
    print(userCredential.user?.email);
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var user =
        await firestore.collection('users').doc(userCredential.user?.uid).get();
    if (user.exists) {
      return Right('Signin was Successful');
    } else {
      await firestore
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set({
            'full_name': FirebaseAuth.instance.currentUser?.displayName,
            'email': FirebaseAuth.instance.currentUser?.email,
          });
      return Right('Signin was Successful');
    }
  }

  @override
  Future<Either> signOut() async {
    await FirebaseAuth.instance.signOut();
    return const Right('Signout was Successful');
  }

  @override
  Future<Either> getUser() async {
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      var user =
          await firestore.collection('users').doc(auth.currentUser!.uid).get();

      UserModel userModel = UserModel.fromJson(user.data()!);
      userModel.imageUrl =
          auth.currentUser?.photoURL ??
          'https://static.vecteezy.com/system/resources/previews/009/292/244/non_2x/default-avatar-icon-of-social-media-user-vector.jpg';
      UserEntity userEntity = userModel.toEntity();
      return Right(userEntity);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
