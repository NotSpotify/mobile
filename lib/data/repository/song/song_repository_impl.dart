import 'package:dartz/dartz.dart';
import 'package:notspotify/data/sources/song/song_firebase_service.dart';
import 'package:notspotify/domain/entities/song/song.dart';
import 'package:notspotify/domain/repository/song/song_repo.dart';
import 'package:notspotify/service_locator.dart';

class SongRepositoryImpl extends SongRepo {
  @override
  Future<Either> addSongToFavourite(SongEntity song) async {
    return await sl<SongFirebaseService>().addSongToFavourite(song);
  }

  @override
  Future<Either> removeSongFromFavourite(SongEntity song) async {
    return await sl<SongFirebaseService>().removeSongFromFavourite(song);
  }

  @override
  Future<Either> getRandom() async {
    return await sl<SongFirebaseService>().getRandom();
  }

  @override
  Future<Either> recommend() async {
    return await sl<SongFirebaseService>().recommend();
  }

  @override
  Future<Either> searchSongs(String query) {
    throw UnimplementedError();
  }

  @override
  Future<Either> addRecently(SongEntity song) {
    return sl<SongFirebaseService>().addRecently(song);
  }
}
