import 'package:notspotify/domain/entities/song/song.dart';

class PlaylistEntity {
  final String id;
  final String name;
  final String genre;
  final String image;
  final List<SongEntity> songs;

  PlaylistEntity({
    required this.id,
    required this.name,
    required this.genre,
    required this.image,
    required this.songs,
  });

  PlaylistEntity copyWith({
    String? id,
    String? name,
    String? genre,
    String? image,
    List<SongEntity>? songs,
  }) {
    return PlaylistEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      genre: genre ?? this.genre,
      image: image ?? this.image,
      songs: songs ?? this.songs,
    );
  }



  @override
  String toString() =>
      'PlaylistEntity(name: $name, genre: $genre, songs: ${songs.length})';
}
