import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:notspotify/core/config/assets/app_images.dart';
import 'package:notspotify/core/config/assets/app_vectors.dart';
import 'package:notspotify/presentation/home/bloc/song_cubit.dart';
import 'package:notspotify/presentation/home/widgets/discovery_song.dart';
import 'package:notspotify/presentation/home/widgets/recommendation_song.dart';

class DiscoveryTab extends StatefulWidget {
  const DiscoveryTab({super.key});

  @override
  State<DiscoveryTab> createState() => _DiscoveryTabState();
}

class _DiscoveryTabState extends State<DiscoveryTab> {
  final SongCubit _randomSongCubit = SongCubit();
  final SongCubit _recommendSongCubit = SongCubit();

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
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _topCard(),
            const SizedBox(height: 30),
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
