import 'package:flutter/material.dart';
import 'package:notspotify/common/constants/gerne_icon_map.dart';
import 'package:notspotify/domain/entities/playlist/playlist.dart';

class GenrePlaylist extends StatelessWidget {
  final List<PlaylistEntity> playlists;
  final void Function(PlaylistEntity playlist) onTap;

  const GenrePlaylist({
    super.key,
    required this.playlists,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (playlists.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "🎧 Your Genres Playlist",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 250,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: playlists.length,
            itemBuilder: (context, index) {
              final playlist = playlists[index];
              return PlaylistCard(
                playlist: playlist,
                onTap: () => onTap(playlist),
                onPlay: () {
                  // Nếu cần xử lý play riêng biệt
                  // Ví dụ gọi NowPlayingCubit hoặc AudioPlayerHandler tại đây
                },
              );
            },
            separatorBuilder: (_, __) => const SizedBox(width: 14),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}

class PlaylistCard extends StatelessWidget {
  final PlaylistEntity playlist;
  final VoidCallback? onTap;
  final VoidCallback? onPlay;

  const PlaylistCard({
    super.key,
    required this.playlist,
    this.onTap,
    this.onPlay,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 160,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      image: DecorationImage(
                        image: NetworkImage(playlist.image),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 8,
                    bottom: 8,
                    child: GestureDetector(
                      onTap: onPlay,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: Colors.black54,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.play_arrow,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Text(
                playlist.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  Icon(
                    genreIconMap[playlist.genre] ?? Icons.music_note,
                    size: 14,
                    color: Colors.green,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    playlist.genre,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
