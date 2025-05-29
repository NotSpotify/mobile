import 'package:dartz/dartz.dart';
import 'package:notspotify/domain/entities/song/song.dart';

abstract class SongRepo {
  Future<Either> addSongToFavourite(SongEntity song);
  Future<Either> removeSongFromFavourite(SongEntity song);
  Future<Either> recommend();
  Future<Either> addRecently(SongEntity song);
  Future<Either> getRandom();
  Future<Either> searchSongs(String query);
  Future<Either> generatePlaylist(List<String> genres);
}
