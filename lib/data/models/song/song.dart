import 'package:notspotify/core/config/assets/app_images.dart';

class SongModel {
  final String spotifyId;
  final String name;
  final String artist;
  final String img;
  final bool preview;
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
    : spotifyId = json['spotifyId'],
      name = json['name'],
      artist = json['artist'],
      img = json['img'] ?? AppImages.defaultImg,
      preview = json['preview'] ?? false,
      duration = json['duration'] ?? 0.0;
}
