import 'package:notspotify/data/models/song/song.dart';
import 'package:notspotify/domain/entities/playlist/playlist.dart';

class PlaylistModel {
  final String id;
  final String name;
  final String genre;
  final String image;
  final List<SongModel> songs;

  PlaylistModel({
    required this.id,
    required this.name,
    required this.genre,
    required this.image,
    required this.songs,
  });

  factory PlaylistModel.fromJson(Map<String, dynamic> json) {
    return PlaylistModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      genre: json['genre'] ?? '',
      image: json['image'] ?? '',
      songs:
          (json['songs'] as List<dynamic>)
              .map((s) => SongModel.fromJson(s as Map<String, dynamic>))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'genre': genre,
    'image': image,
    'songs': songs.map((s) => s.toJson()).toList(),
  };
}


extension PlaylistModelX on PlaylistModel {
  PlaylistEntity toEntity() => PlaylistEntity(
    id: id,
    name: name,
    genre: genre,
    image: image,
    songs: songs.map((s) => s.toEntity()).toList(),
  );

  static PlaylistModel fromEntity(PlaylistEntity entity) => PlaylistModel(
    id: entity.id,
    name: entity.name,
    genre: entity.genre,
    image: entity.image,
    songs: entity.songs.map(SongModelX.fromEntity).toList(),
  );
}
