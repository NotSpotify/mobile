import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notspotify/domain/entities/playlist/playlist.dart';
import 'package:notspotify/domain/usecases/song/add_recently.dart';
import 'package:notspotify/presentation/home/bloc/now_playing_cubit.dart';
import 'package:notspotify/presentation/home/bloc/play_status.dart';
import 'package:notspotify/common/handler/audio_handler.dart';
import 'package:notspotify/service_locator.dart';

class PlaylistDetailScreen extends StatelessWidget {
  final PlaylistEntity playlist;

  const PlaylistDetailScreen({super.key, required this.playlist});

  @override
  Widget build(BuildContext context) {
    final songs = playlist.songs;

    return Scaffold(
      body: Container(
        color: Colors.white,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 100),
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  playlist.songs.isNotEmpty ? playlist.songs[0].img : '',
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (_, __, ___) => Container(
                        width: 200,
                        height: 200,
                        color: Colors.grey.shade300,
                        child: const Icon(
                          Icons.music_note,
                          color: Colors.black,
                          size: 50,
                        ),
                      ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                playlist.name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                '${songs.length} songs',
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton.icon(
                onPressed: () async {
                  await sl<AddRecentlyUseCase>().call(
                    params: songs[0],
                  );
                  if (songs.isNotEmpty && songs[0].preview.isNotEmpty) {
                    context.read<NowPlayingCubit>().setSong(songs[0]);
                    AudioPlayerHandler.play(songs[0].preview);
                    context.read<PlayingStatusCubit>().play();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('No preview available'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1DB954),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                icon: const Icon(Icons.play_arrow, color: Colors.black),
                label: const Text(
                  'Play All',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ...songs.map(
              (song) => ListTile(
                contentPadding: const EdgeInsets.symmetric(vertical: 4),
                leading: ClipOval(
                  child: Image.network(
                    song.img,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (_, __, ___) => Container(
                          width: 50,
                          height: 50,
                          color: Colors.grey.shade300,
                          child: const Icon(
                            Icons.music_note,
                            color: Colors.black,
                          ),
                        ),
                  ),
                ),
                title: Text(
                  song.name,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  song.artist,
                  style: TextStyle(color: Colors.grey.shade600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: IconButton(
                  icon: const Icon(
                    Icons.play_circle_outline,
                    color: Colors.black,
                  ),
                  onPressed: () async {
                    print(song);
                    await sl<AddRecentlyUseCase>().call(params: {'song': song});
                    if (song.preview.isNotEmpty) {
                      context.read<NowPlayingCubit>().setSong(song);
                      AudioPlayerHandler.play(song.preview);
                      context.read<PlayingStatusCubit>().play();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${song.name} has no preview'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                ),
                onTap: ()  async {
                    await sl<AddRecentlyUseCase>().call(params: {'song': song});

                  if (song.preview.isNotEmpty) {
                    context.read<NowPlayingCubit>().setSong(song);
                    AudioPlayerHandler.play(song.preview);
                    context.read<PlayingStatusCubit>().play();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
