import 'package:flutter/material.dart';
import 'package:notspotify/common/helpers/playlist/playlist.dart';
import 'package:notspotify/presentation/home/widgets/recommendation_song.dart';

class GenrePlaylistsSection extends StatelessWidget {
  final String genre;
  final List<PlaylistTemplate> playlists;

  const GenrePlaylistsSection({
    super.key,
    required this.genre,
    required this.playlists,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              genreIconMap[genre] ?? Icons.library_music,
              color: Colors.green,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              genre,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 200,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: playlists.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (_, index) {
              final playlist = playlists[index];
              return GestureDetector(
                onTap: () {
                  // TODO: Navigate to playlist detail screen
                },
                child: SizedBox(
                  width: 150,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(
                          playlist.imageUrl,
                          height: 140,
                          width: 150,
                          fit: BoxFit.cover,
                          errorBuilder:
                              (_, __, ___) => Container(
                                height: 140,
                                width: 150,
                                color: Colors.grey.shade300,
                                child: const Icon(Icons.music_note),
                              ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        playlist.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        playlist.genre,
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
