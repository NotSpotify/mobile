import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:notspotify/common/widgets/appbar/basic_app_bar.dart';
import 'package:notspotify/core/config/assets/app_images.dart';
import 'package:notspotify/core/config/assets/app_vectors.dart';
import 'package:notspotify/presentation/favourite/pages/favourite.dart';
import 'package:notspotify/presentation/home/bloc/song_cubit.dart';
import 'package:notspotify/presentation/home/widgets/mini_player.dart';
import 'package:notspotify/presentation/home/widgets/discovery_song.dart';
import 'package:notspotify/presentation/home/widgets/recommendation_song.dart';
import 'package:notspotify/presentation/profile/pages/profile.dart';
import 'package:notspotify/presentation/search/pages/search.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final SongCubit _randomSongCubit = SongCubit();
  final SongCubit _recommendSongCubit = SongCubit();
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _randomSongCubit.getRandomSong(); // Load random khi vào
    _recommendSongCubit.recommend(); // Load recommend khi vào
  }

  @override
  void dispose() {
    _randomSongCubit.close();
    _recommendSongCubit.close();
    super.dispose();
  }

  List<Widget> get _pages => [
    _buildDiscoveryPage(),
    const SearchPage(),
    const FavouritePage(), // Ví dụ thêm 1 trang Settings
    const ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildDiscoveryPage() {
    return RefreshIndicator(
      onRefresh: () async {
        await _randomSongCubit.getRandomSong();
        await _recommendSongCubit.recommend();
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _homeTopCard(),
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
      ),
    );
  }

  Widget _homeTopCard() {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppBar(
        hideBack: true,
        title: SvgPicture.asset(AppVectors.logo, height: 40, width: 40),
      ),
      body: Stack(
        children: [
          _pages[_selectedIndex], // Hiển thị page tương ứng
          const Align(alignment: Alignment.bottomCenter, child: MiniPlayer()),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: true, // Hiển thị label khi được chọn
        showUnselectedLabels: true, // Không hiển thị label khi không được chọn
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        onTap: _onItemTapped,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Discover'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favourite',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
