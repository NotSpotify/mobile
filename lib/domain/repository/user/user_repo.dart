import 'package:dartz/dartz.dart';

abstract class UserRepository {
  Future<Either> getUserGenres();
  Future<Either> uploadGeneratePlaylists(List<String> genres);
  Future<Either> fetchPlaylistsFromFirestore();
}
