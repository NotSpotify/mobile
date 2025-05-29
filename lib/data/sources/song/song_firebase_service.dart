import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:notspotify/common/auth/auth_service.dart';
import 'package:notspotify/core/config/enum/baseURL.dart';
import 'package:notspotify/data/models/song/song.dart';
import 'package:notspotify/domain/entities/song/song.dart';
import 'package:notspotify/service_locator.dart';

abstract class SongFirebaseService {
  Future<Either> addSongToFavourite(SongEntity song);
  Future<Either> removeSongFromFavourite(SongEntity song);
  Future<Either> recommend();
  Future<Either> addRecently(SongEntity song);
  Future<Either> getRandom();
  Future<Either> searchSongs(String query);
}

class SongFirebaseServiceImpl extends SongFirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthService _authService = sl<AuthService>();

  Future<Either<String, bool>> addSongToFavourite(SongEntity song) async {
    try {
      final userId = sl<AuthService>().getCurrentUserId();
      if (userId == null) return Left('Not logged in');

      final firestore = FirebaseFirestore.instance;
      await firestore
          .collection('users')
          .doc(userId)
          .collection('favourites')
          .doc(song.spotifyId)
          .set({
            'spotifyId': song.spotifyId,
            'name': song.name,
            'artist': song.artist,
            'img': song.img,
            'preview': song.preview,
            'duration': song.duration,
            'addedAt': FieldValue.serverTimestamp(),
          });

      return const Right(true);
    } catch (e) {
      return Left('Failed to add to favourites: $e');
    }
  }

  @override
  Future<Either<String, bool>> removeSongFromFavourite(SongEntity song) async {
    try {
      final userId = sl<AuthService>().getCurrentUserId();
      if (userId == null) return Left('Not logged in');

      final firestore = FirebaseFirestore.instance;
      await firestore
          .collection('users')
          .doc(userId)
          .collection('favourites')
          .doc(song.spotifyId)
          .delete();

      return const Right(true);
    } catch (e) {
      return Left('Failed to remove from favourites: $e');
    }
  }

  @override
  Future<Either<String, List<SongEntity>>> recommend() async {
    try {
      final userId = _authService.getCurrentUserId();
      if (userId == null) {
        return Left('User not logged in');
      }

      final snapshot =
          await _firestore
              .collection('users')
              .doc(userId)
              .collection('recently_played')
              .orderBy('playedAt', descending: true)
              .limit(1)
              .get();

      final idToUse =
          snapshot.docs.isNotEmpty
              ? (snapshot.docs.first.data()['spotifyId'] ??
                  '2Fw5S2gaOSZzdN5dFoC2dj')
              : '2Fw5S2gaOSZzdN5dFoC2dj';

      final response = await http.get(
        Uri.parse('${Baseurl.baseUrl}recommend/?sp_id=$idToUse'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is! List) {
          return Left('Invalid response format');
        }

        final songs =
            data
                .map<SongModel>((songJson) => SongModel.fromJson(songJson))
                .toList();
        final entities = songs.map((song) => song.toEntity()).toList();

        return Right(entities);
      } else {
        return Left(
          'Failed to load recommendations. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error in recommend: $e');
      return Left('Error: $e');
    }
  }

  @override
  Future<Either<String, List<SongEntity>>> getRandom() async {
    try {
      final response = await http.get(
        Uri.parse('${Baseurl.baseUrl}random_songs'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is! List) {
          return Left('Invalid response format');
        }

        final songs =
            data
                .map<SongModel>((songJson) => SongModel.fromJson(songJson))
                .toList();
        final entities = songs.map((song) => song.toEntity()).toList();

        return Right(entities);
      } else {
        return Left(
          'Failed to load random songs. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error in getRandom: $e');
      return Left('Error: $e');
    }
  }

  @override
  Future<Either<String, List<SongEntity>>> searchSongs(String query) async {
    // TODO: Implement searching songs
    return Right([]);
  }

  @override
  Future<Either<String, bool>> addRecently(SongEntity song) async {
    final userId = _authService.getCurrentUserId();
    if (userId == null) {
      return Left('User not logged in');
    }

    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('recently_played')
          .add({
            'spotifyId': song.spotifyId,
            'name': song.name,
            'artist': song.artist,
            'img': song.img,
            'preview': song.preview,
            'duration': song.duration,
            'playedAt': FieldValue.serverTimestamp(),
          });
      return const Right(true);
    } catch (e) {
      print('Error in addRecently: $e');
      return Left('Error adding to recently played: $e');
    }
  }
}
