import 'package:dartz/dartz.dart';
import 'package:notspotify/data/sources/user/user_firebase_service.dart';
import 'package:notspotify/domain/repository/user/user_repo.dart';
import 'package:notspotify/service_locator.dart';

class UserRepositoryImpl extends UserRepository {
  final _userService = sl<UserFirebaseService>();

  @override
  Future<Either> getUserGenres() async {
    return await _userService.getUserGenres();
  }

  @override
  Future<Either>
  fetchPlaylistsFromFirestore() async {
    return await _userService.fetchPlaylistsFromFirestore();
  }

 @override
  Future<Either> uploadGeneratePlaylists(
    List<String> genres
  ) async {
    return await _userService.uploadGeneratePlaylists(genres);
  }
}