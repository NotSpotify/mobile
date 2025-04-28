import 'package:dartz/dartz.dart';

abstract class SongRepo {
  Future<Either> addSongToFavourite(String spotifyId);
  Future<Either> removeSongFromFavourite(String spotifyId);
  Future<List<Either>> recommend(String spotifyId);
  Future<List<String>> getRandom(String spotifyId);
  Future<Either> searchSongs(String query);
}