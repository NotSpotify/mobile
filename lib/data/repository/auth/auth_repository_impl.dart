import 'package:dartz/dartz.dart';
import 'package:notspotify/data/models/auth/create_user_req.dart';
import 'package:notspotify/data/models/auth/signin_user_req.dart';
import 'package:notspotify/data/sources/auth/auth_firebase_service.dart';
import 'package:notspotify/domain/repository/auth/auth_repo.dart';
import 'package:notspotify/service_locator.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
    return sl<AuthFirebaseService>().signOut();
  }

  @override
  Future<Either> updateUserProfile(String fullName, String email) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Update in Firebase Auth
        await user.updateDisplayName(fullName);
        await user.updateEmail(email);

        // Update in Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({'full_name': fullName, 'email': email});

        return Right(user);
      }
      return Left(Exception('User not found'));
    } catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either> updateUserProfileImage(String imagePath) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Upload to Firebase Storage
        final ref = FirebaseStorage.instance
            .ref()
            .child('user_images')
            .child('${user.uid}.jpg');

        await ref.putFile(File(imagePath));
        final imageUrl = await ref.getDownloadURL();

        // Update in Firebase Auth
        await user.updatePhotoURL(imageUrl);

        // Update in Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({'image_url': imageUrl});

        return Right(imageUrl);
      }
      return Left(Exception('User not found'));
    } catch (e) {
      return Left(e);
    }
  }
  @override
  Future<Either> updateGerne(String userId, List<String> genres) {
    return sl<AuthFirebaseService>().updateGerne(userId, genres);
  }
}


  

