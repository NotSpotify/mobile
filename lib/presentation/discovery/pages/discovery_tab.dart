import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:notspotify/core/config/assets/app_images.dart';
import 'package:notspotify/core/config/assets/app_vectors.dart';
import 'package:notspotify/domain/entities/playlist/playlist.dart';
import 'package:notspotify/domain/usecases/user/fetch_playlist.dart';
import 'package:notspotify/presentation/discovery/bloc/song_cubit.dart';
import 'package:notspotify/presentation/home/widgets/gerne_playlist.dart';
import 'package:notspotify/presentation/home/widgets/playlist_screen.dart';
import 'package:notspotify/presentation/home/widgets/recommendation_song.dart';
import 'package:notspotify/presentation/home/widgets/song_widget.dart';
import 'package:notspotify/service_locator.dart';

class DiscoveryTab extends StatefulWidget {
   final Function(Widget) onOpenPlaylist;

  const DiscoveryTab({super.key, required this.onOpenPlaylist});
  @override
  State<DiscoveryTab> createState() => _DiscoveryTabState();
}

class _DiscoveryTabState extends State<DiscoveryTab> {
  final SongCubit _randomSongCubit = SongCubit();
  final SongCubit _recommendSongCubit = SongCubit();
  final _fetchPlaylistUseCase = sl<FetchPlaylistUseCase>();

  @override
  void initState() {
    super.initState();
    _randomSongCubit.getRandomSong();
    _recommendSongCubit.recommend();
  }

  @override
  void dispose() {
    _randomSongCubit.close();
    _recommendSongCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await _randomSongCubit.getRandomSong();
        await _recommendSongCubit.recommend();
        setState(() {}); // Refresh playlists too
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _topCard(),
            const SizedBox(height: 30),

            FutureBuilder(
              future: _fetchPlaylistUseCase.call(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }

                final result = snapshot.data;
                if (result == null) return const SizedBox.shrink();

                return result.fold(
                  (error) => Text(
                    "❌ $error",
                    style: const TextStyle(color: Colors.red),
                  ),
                  (playlists) {
                    final casted = playlists as List<PlaylistEntity>;
                  return GenrePlaylist(
                      playlists: casted,
                      onTap: (playlist) {
                        widget.onOpenPlaylist(
                          PlaylistDetailScreen(playlist: playlist),
                        );
                      },
                    );               },
                );
              },
            ),

            const Text(
              "Discover New Songs",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SongWidget(cubit: _randomSongCubit),
            const SizedBox(height: 20),
            const Text(
              "Your Recommendations",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            RecommendWidget(cubit: _recommendSongCubit),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _topCard() {
    return Center(
      child: SizedBox(
        height: 188,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: SvgPicture.asset(AppVectors.homeTopCard),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Image.asset(AppImages.obito, height: 250, width: 250),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
