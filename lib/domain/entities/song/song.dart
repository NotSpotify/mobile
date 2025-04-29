
class SongEntity {
  final String spotifyId;
  final String name;
  final String artist;
  final String img;
  final String preview;
  final num? duration;

  SongEntity({
    required this.spotifyId,
    required this.name,
    required this.artist,
    required this.img,
    required this.preview,
    required this.duration,
  });
}
