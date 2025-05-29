import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notspotify/common/auth/auth_service.dart';
import 'package:notspotify/common/handler/audio_handler.dart';
import 'package:notspotify/core/config/theme/app_colors.dart';
import 'package:notspotify/domain/entities/song/song.dart';
import 'package:notspotify/presentation/home/bloc/now_playing_cubit.dart';
import 'package:notspotify/presentation/home/bloc/play_status.dart';
import 'package:notspotify/service_locator.dart';

class FavouritePage extends StatefulWidget {
  const FavouritePage({super.key});

  @override
  State<FavouritePage> createState() => _FavouritePageState();
}

class _FavouritePageState extends State<FavouritePage> {
  List<Map<String, dynamic>> _favourites = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavourites();
  }

  Future<void> _loadFavourites() async {
    final userId = sl<AuthService>().getCurrentUserId();
    if (userId == null) {
      if (!mounted) return;
      setState(() {
        _favourites = [];
        _isLoading = false;
      });
      return;
    }

    try {
      final snapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .collection('favourites')
              .get();

      final favouriteSongs = snapshot.docs.map((doc) => doc.data()).toList();

      if (!mounted) return;
      setState(() {
        _favourites = favouriteSongs;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading favourites: $e');
      if (!mounted) return;
      setState(() {
        _favourites = [];
        _isLoading = false;
      });
    }
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
        child:
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _favourites.isEmpty
                ? Center(
                  child: Text(
                    'No favourite songs yet',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                  ),
                )
                : ListView.builder(
                  itemCount: _favourites.length,
                  itemBuilder: (context, index) {
                    final item = _favourites[index];
                    return Padding(
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
                                    ? const Icon(Icons.favorite_border)
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
                          trailing: IconButton(
                            icon: Icon(
                              Icons.delete_outline,
                              color: primaryColor,
                            ),
                            onPressed: () async {
                              final userId =
                                  sl<AuthService>().getCurrentUserId();
                              if (userId == null) return;

                              try {
                                await FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(userId)
                                    .collection('favourites')
                                    .doc(
                                      item['spotifyId'],
                                    ) // 🔥 Xóa theo đúng id
                                    .delete();

                                setState(() {
                                  _favourites.removeAt(index);
                                });

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Removed from Favourites'),
                                  ),
                                );
                              } catch (e) {
                                print('Error removing from favourites: $e');
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Failed to remove'),
                                  ),
                                );
                              }
                            },
                          ),
                          onTap: () {
                            final previewUrl = item['preview'];

                            if (previewUrl != null && previewUrl.isNotEmpty) {
                              context.read<NowPlayingCubit>().setSong(
                                SongEntity(
                                  spotifyId: item['spotifyId'] ?? '',
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
                              ScaffoldMessenger.of(context).showSnackBar(
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
                    );
                  },
                ),
      ),
    );
  }
}
