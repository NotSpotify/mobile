import 'package:notspotify/core/config/assets/app_images.dart';

class SongEntity {
  final String spotifyId;
  final String name;
  final String artist;
  final String img;
  final bool preview;
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
