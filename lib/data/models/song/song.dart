import 'package:notspotify/core/config/assets/app_images.dart';
import 'package:notspotify/domain/entities/song/song.dart';

class SongModel {
  final String spotifyId;
  final String name;
  final String artist;
  final String img;
  final String preview;
  final num? duration;

  SongModel({
    required this.spotifyId,
    required this.name,
    required this.artist,
    required this.img,
    required this.preview,
    required this.duration,
  });

  SongModel.fromJson(Map<String, dynamic> json)
    : spotifyId = json['spotify_id'] ?? '',
      name = json['name'] ?? '',
      artist = json['artist'] ?? '',
      img = json['img'] ?? AppImages.defaultImg,
      preview = json['preview'] ?? '',
      duration = json['duration'] ?? 0.0;
}

extension SongModelX on SongModel {
  SongEntity toEntity() {
    return SongEntity(
      spotifyId: spotifyId,
      name: name,
      artist: artist,
      img: img,
      preview: preview,
      duration: duration,
    );
  }
}
