import 'package:notspotify/domain/entities/song/song.dart';

abstract class RandomSongState {}

class RandomSongLoading extends RandomSongState {}

class RandomSongLoaded extends RandomSongState {
  final List<SongEntity> songs;

  RandomSongLoaded(this.songs);
}

class RandomSongError extends RandomSongState {
  final String message;
  RandomSongError(this.message);
}
