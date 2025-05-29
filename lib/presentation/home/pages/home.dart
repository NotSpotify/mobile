import 'package:flutter/material.dart';
import 'package:notspotify/common/widgets/appbar/basic_app_bar.dart';
import 'package:notspotify/presentation/discovery/pages/discovery_tab.dart';
import 'package:notspotify/presentation/favourite/pages/favourite.dart';
import 'package:notspotify/presentation/profile/pages/profile.dart';
import 'package:notspotify/presentation/search/pages/search.dart';
import 'package:notspotify/presentation/home/widgets/mini_player.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  Widget? _currentInnerPage;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();

    _pages = [
      DiscoveryTab(onOpenPlaylist: openPlaylistDetail),
      const SearchPage(),
      const FavouritePage(),
      const ProfilePage(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _currentInnerPage = null; // reset về tab gốc khi chuyển tab
    });
  }

  void openPlaylistDetail(Widget playlistDetailScreen) {
    setState(() {
      _currentInnerPage = playlistDetailScreen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppBar(
        hideBack: _currentInnerPage == null,
        onBack: () {
          setState(() => _currentInnerPage = null);
        },
      ),
      body: Stack(
        children: [
          _currentInnerPage ?? _pages[_selectedIndex],
          const Align(alignment: Alignment.bottomCenter, child: MiniPlayer()),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
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
