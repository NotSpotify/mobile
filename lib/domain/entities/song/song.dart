class SongEntity {
  final String spotifyId;
  final String name;
  final String artist;
  final String img;
  final String preview;
  final num? duration;
  final int? musicCluster;
  final String? musicGenreLabel;

  SongEntity({
    required this.spotifyId,
    required this.name,
    required this.artist,
    required this.img,
    required this.preview,
    required this.duration,
    this.musicCluster,
    this.musicGenreLabel,
  });

  SongEntity copyWith({
    String? spotifyId,
    String? name,
    String? artist,
    String? img,
    String? preview,
    num? duration,
    int? musicCluster,
    String? musicGenreLabel,
  }) {
    return SongEntity(
      spotifyId: spotifyId ?? this.spotifyId,
      name: name ?? this.name,
      artist: artist ?? this.artist,
      img: img ?? this.img,
      preview: preview ?? this.preview,
      duration: duration ?? this.duration,
      musicCluster: musicCluster ?? this.musicCluster,
      musicGenreLabel: musicGenreLabel ?? this.musicGenreLabel,
    );
  }

  @override
  String toString() =>
      'SongEntity(name: $name, artist: $artist, cluster: $musicCluster, label: $musicGenreLabel)';
}
