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
  Future<Either> updateGerne(String userId, List<String> genres);

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

class AuthFirebaseServiceImpl implements AuthFirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<Either> signUpWithEmailAndPassword(CreateUserReq createUserReq) async {
    try {
      var data = await _auth.createUserWithEmailAndPassword(
        email: createUserReq.email,
        password: createUserReq.password,
      );

      await _firestore.collection('users').doc(data.user!.uid).set({
        'full_name': createUserReq.fullName,
        'email': createUserReq.email,
        'image_url': createUserReq.imageUrl,
      });

      return const Right('Signup was Successful');
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
      await _auth.signInWithEmailAndPassword(
        email: signinUserReq.email,
        password: signinUserReq.password,
      );
      return const Right('Signin was Successful');
    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == 'invalid-email') {
        message = 'No user found for that email';
      } else if (e.code == 'invalid-credential') {
        message = 'Wrong password provided for that user';
      }
      return Left(message);
    }
  }

  @override
  Future<Either> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    final userCredential = await _auth.signInWithCredential(credential);

    final docRef = _firestore.collection('users').doc(userCredential.user?.uid);
    final snapshot = await docRef.get();

    if (!snapshot.exists) {
      await docRef.set({
        'full_name': userCredential.user?.displayName,
        'email': userCredential.user?.email,
        'image_url': userCredential.user?.photoURL,
        'has_chosen_genre': false,
        'genre_preference': [],
      });
    }

    return const Right('Signin was Successful');
  }

  @override
  Future<Either> signOut() async {
    await _auth.signOut();
    return const Right('Signout was Successful');
  }

  @override
  Future<Either<String, UserEntity>> getUser() async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        return const Left('User not logged in.');
      }

      final userDoc =
          await _firestore.collection('users').doc(currentUser.uid).get();

      if (!userDoc.exists) return const Left('User profile not found.');
      final userData = userDoc.data();
      if (userData == null) return const Left('User data is empty.');

      final userModel = UserModel.fromJson(userData);
      userModel.imageUrl =
          currentUser.photoURL ??
          'https://static.vecteezy.com/system/resources/previews/009/292/244/non_2x/default-avatar-icon-of-social-media-user-vector.jpg';

      return Right(userModel.toEntity());
    } catch (e) {
      return Left('Error: ${e.toString()}');
    }
  }
  
  @override
  Future<Either<String, void>> updateGerne(
    String userId,
    List<String> genres,
  ) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'has_chosen_genre': true,
        'genre_preference': genres,
      });
      return const Right(null);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
