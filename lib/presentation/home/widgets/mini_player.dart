import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notspotify/common/handler/audio_handler.dart';
import 'package:notspotify/domain/entities/song/song.dart';
import 'package:notspotify/presentation/home/bloc/now_playing_cubit.dart';
import 'package:notspotify/presentation/home/bloc/play_status.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NowPlayingCubit, SongEntity?>(
      builder: (context, song) {
        if (song == null) return const SizedBox.shrink();

        return Container(
          margin: const EdgeInsets.all(8),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          height: 60,
          decoration: BoxDecoration(
            color: Colors.black87,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  song.img,
                  height: 40,
                  width: 40,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      song.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      song.artist,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              BlocBuilder<PlayingStatusCubit, PlayingStatus>(
                builder: (context, status) {
                  final isPlaying = status == PlayingStatus.playing;
                  return IconButton(
                    icon: Icon(
                      isPlaying ? Icons.pause : Icons.play_arrow,
                      color: Colors.white,
                      size: 28,
                    ),
                    onPressed: () {
                      if (isPlaying) {
                        AudioPlayerHandler.pause();
                        context.read<PlayingStatusCubit>().pause();
                      } else {
                        AudioPlayerHandler.resume();
                        context.read<PlayingStatusCubit>().play();
                      }
                    },
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
