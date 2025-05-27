import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notspotify/common/handler/audio_handler.dart';
import 'package:notspotify/domain/entities/song/song.dart';
import 'package:notspotify/domain/usecases/song/add_recently.dart';
import 'package:notspotify/domain/usecases/song/add_to_favourite.dart';
import 'package:notspotify/domain/usecases/song/remove_from_favourite.dart';
import 'package:notspotify/presentation/home/bloc/now_playing_cubit.dart';
import 'package:notspotify/presentation/home/bloc/play_status.dart';
import 'package:notspotify/presentation/home/bloc/song_cubit.dart';
import 'package:notspotify/presentation/home/bloc/songs_state.dart';
import 'package:notspotify/service_locator.dart';

final genreIconMap = {
  'Chill': Icons.spa,
  'Dance': Icons.directions_run,
  'Acoustic': Icons.music_note,
  'Energetic': Icons.flash_on,
  'Emotional': Icons.favorite,
  'Experimental': Icons.auto_awesome,
};

class RecommendWidget extends StatelessWidget {
  final SongCubit cubit;

  const RecommendWidget({super.key, required this.cubit});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: cubit,
      child: SizedBox(
        height: 250,
        child: BlocBuilder<SongCubit, RandomSongState>(
          builder: (context, state) {
            if (state is RandomSongLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is RandomSongLoaded) {
              return _songs(state.songs);
            } else if (state is RandomSongError) {
              return Center(child: Text(state.message));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _songs(List<SongEntity> songs) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        final song = songs[index];
        return SizedBox(
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
                          image: NetworkImage(song.img),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 8,
                      bottom: 8,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.play_arrow,
                            color: Colors.white,
                          ),
                          onPressed: () async {
                            await sl<AddRecentlyUseCase>().call(
                              params: {'song': song},
                            );
                            context.read<NowPlayingCubit>().setSong(song);
                            AudioPlayerHandler.play(song.preview);
                            context.read<PlayingStatusCubit>().play();
                          },
                        ),
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: PopupMenuButton<String>(
                        onSelected: (value) async {
                          if (value == 'add') {
                            await sl<AddToFavouriteUseCase>().call(
                              params: {
                                'song': song, // 🔥 Truyền full SongEntity
                              },
                            );
                          } else if (value == 'remove') {
                            await sl<RemoveFromFavouriteUseCase>().call(
                              params: {
                                'spotifyId':
                                    song.spotifyId, // ✅ Remove chỉ cần id
                              },
                            );
                          }
                        },
                        itemBuilder:
                            (context) => [
                              const PopupMenuItem(
                                value: 'add',
                                child: Text('Add to Favourite'),
                              ),
                              const PopupMenuItem(
                                value: 'remove',
                                child: Text('Remove from Favourite'),
                              ),
                            ],
                        icon: const Icon(Icons.more_horiz, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  song.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  song.artist,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 5),
                if (song.musicGenreLabel != null)
                  Row(
                    children: [
                      Icon(
                        genreIconMap[song.musicGenreLabel!] ?? Icons.music_note,
                        size: 14,
                        color: Colors.green,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        song.musicGenreLabel!,
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
        );
      },
      separatorBuilder: (context, index) => const SizedBox(width: 14),
      itemCount: songs.length,
    );
  }
}
