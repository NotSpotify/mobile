import 'package:notspotify/core/config/assets/app_images.dart';
import 'package:notspotify/domain/entities/song/song.dart';

class SongModel {
  final String spotifyId;
  final String name;
  final String artist;
  final String img;
  final String preview;
  final num? duration;
  final int? musicCluster;
  final String? musicGenreLabel;

  SongModel({
    required this.spotifyId,
    required this.name,
    required this.artist,
    required this.img,
    required this.preview,
    required this.duration,
    this.musicCluster,
    this.musicGenreLabel,
  });

  SongModel.fromJson(Map<String, dynamic> json)
    : spotifyId = json['spotify_id'] ?? '',
      name = json['name'] ?? '',
      artist = json['artist'] ?? '',
      img = json['img'] ?? AppImages.defaultImg,
      preview = json['preview'] ?? '',
      duration = json['duration'] ?? 0.0,
      musicCluster = json['music_cluster'],
      musicGenreLabel = json['music_genre_label'];

  Map<String, dynamic> toJson() => {
    'spotify_id': spotifyId,
    'name': name,
    'artist': artist,
    'img': img,
    'preview': preview,
    'duration': duration,
    'music_cluster': musicCluster,
    'music_genre_label': musicGenreLabel,
  };
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
      musicCluster: musicCluster,
      musicGenreLabel: musicGenreLabel,
    );
  }

  static SongModel fromEntity(SongEntity entity) {
    return SongModel(
      spotifyId: entity.spotifyId,
      name: entity.name,
      artist: entity.artist,
      img: entity.img,
      preview: entity.preview,
      duration: entity.duration,
      musicCluster: entity.musicCluster,
      musicGenreLabel: entity.musicGenreLabel,
    );
  }
}
