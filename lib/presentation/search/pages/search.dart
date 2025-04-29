import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notspotify/common/handler/audio_handler.dart';
import 'package:notspotify/core/config/theme/app_colors.dart';
import 'package:notspotify/domain/entities/song/song.dart';
import 'package:notspotify/domain/usecases/song/add_to_favourite.dart';
import 'package:notspotify/presentation/home/bloc/now_playing_cubit.dart';
import 'package:notspotify/presentation/home/bloc/play_status.dart';
import 'package:notspotify/service_locator.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];
  bool _isLoading = false;

  Future<void> _searchData(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final lowerQuery = query.toLowerCase();

      final nameSnapshot =
          await FirebaseFirestore.instance
              .collection('songs') // 🔥 Đổi collection nếu cần
              .where('name_normalized', isGreaterThanOrEqualTo: lowerQuery)
              .where(
                'name_normalized',
                isLessThanOrEqualTo: lowerQuery + '\uf8ff',
              )
              .get();

      final artistSnapshot =
          await FirebaseFirestore.instance
              .collection('songs')
              .where('artist_normalized', isGreaterThanOrEqualTo: lowerQuery)
              .where(
                'artist_normalized',
                isLessThanOrEqualTo: lowerQuery + '\uf8ff',
              )
              .get();

      final result = [...nameSnapshot.docs, ...artistSnapshot.docs];
      setState(() {
        _searchResults = result.map((doc) => doc.data()).toList();
      });
    } catch (e) {
      print('Search error: $e');
      setState(() {
        _searchResults = [];
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? AppColors.darkBG : AppColors.lightBg;

    return Scaffold(
      backgroundColor: backgroundColor,

      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Search Field
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by name...',
                hintStyle: TextStyle(color: Colors.grey.shade500),
                prefixIcon: Icon(Icons.search, color: primaryColor),
                filled: true,
                fillColor: primaryColor.withOpacity(0.1),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 16,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: primaryColor, width: 1.5),
                ),
              ),
              onChanged: (value) {
                _searchData(value.trim());
              },
            ),
            const SizedBox(height: 20),
            // Results
            Expanded(
              child:
                  _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _searchResults.isEmpty
                      ? Center(
                        child: Text(
                          'No results found',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 16,
                          ),
                        ),
                      )
                      : ListView.builder(
                        itemCount: _searchResults.length,
                        itemBuilder: (context, index) {
                          final item = _searchResults[index];
                          return Dismissible(
                            key: Key(
                              item['spotifyId'] ?? index.toString(),
                            ), // mỗi item cần key khác nhau
                            direction:
                                DismissDirection
                                    .endToStart, // kéo từ phải qua trái
                            background: Container(
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green, // màu nền khi quẹt
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.favorite_border,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                            confirmDismiss: (direction) async {
                              // Bắt sự kiện trước khi dismiss
                              final shouldAdd = await showDialog<bool>(
                                context: context,
                                builder:
                                    (context) => AlertDialog(
                                      title: const Text('Add to Favourites'),
                                      content: const Text(
                                        'Do you want to add this song to favourites?',
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed:
                                              () => Navigator.of(
                                                context,
                                              ).pop(false),
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed:
                                              () => Navigator.of(
                                                context,
                                              ).pop(true),
                                          child: const Text('Add'),
                                        ),
                                      ],
                                    ),
                              );

                              if (shouldAdd == true) {
                                // Gọi AddToFavourite
                                await sl<AddToFavouriteUseCase>().call(
                                  params: {
                                    'song': SongEntity(
                                      spotifyId: item['spotify_id'] ?? '',
                                      name: item['name'] ?? '',
                                      artist: item['artist'] ?? '',
                                      img: item['img'] ?? '',
                                      preview: item['preview'] ?? '',
                                      duration: item['duration'] ?? 0,
                                    ),
                                  },
                                );

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Added to favourites!'),
                                  ),
                                );

                                return false; // không remove item khỏi list UI
                              }

                              return false;
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Material(
                                color: primaryColor.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(12),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage:
                                        item['img'] != null
                                            ? NetworkImage(item['img'])
                                            : null,
                                    backgroundColor: Colors.grey.shade200,
                                    child:
                                        item['img'] == null
                                            ? const Icon(Icons.music_note)
                                            : null,
                                  ),
                                  title: Text(
                                    item['name'] ?? 'Unknown',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  subtitle: Text(
                                    item['artist'] ?? '',
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 14,
                                    ),
                                  ),
                                  onTap: () {
                                    final previewUrl = item['preview'];

                                    if (previewUrl != null &&
                                        previewUrl.isNotEmpty) {
                                      context.read<NowPlayingCubit>().setSong(
                                        SongEntity(
                                          spotifyId: item['spotify_id'] ?? '',
                                          name: item['name'] ?? '',
                                          artist: item['artist'] ?? '',
                                          img: item['img'] ?? '',
                                          preview: item['preview'] ?? '',
                                          duration: item['duration'] ?? 0,
                                        ),
                                      );

                                      AudioPlayerHandler.play(previewUrl);
                                      context.read<PlayingStatusCubit>().play();
                                    } else {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Preview not available for this song',
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
