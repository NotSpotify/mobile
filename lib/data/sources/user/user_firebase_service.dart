import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:notspotify/common/auth/auth_service.dart';
import 'package:notspotify/common/helpers/playlist/gerne_map.dart';
import 'package:notspotify/core/config/enum/baseURL.dart';
import 'package:notspotify/data/models/playlist/playlist.dart';
import 'package:notspotify/data/models/song/song.dart';
import 'package:notspotify/domain/entities/playlist/playlist.dart';
import 'package:notspotify/domain/entities/song/song.dart';
import 'package:notspotify/service_locator.dart';

abstract class UserFirebaseService {
  Future<Either> getUserGenres();
  Future<Either> fetchPlaylistsFromFirestore();
  Future<Either> uploadGeneratePlaylists(List<String> genres);
}

class UserFirebaseServiceImpl implements UserFirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthService _authService = sl<AuthService>();

  @override
  Future<Either> getUserGenres() async {
    try {
      final userId = _authService.getCurrentUserId();
      if (userId == null) return Left('User not logged in');

      final doc = await _firestore.collection('users').doc(userId).get();
      final data = doc.data();
      final List<dynamic> rawGenres = data?['genre_preference'] ?? [];

      return Right(rawGenres.cast<String>());
    } catch (e) {
      return Left('Failed to fetch genres: $e');
    }
  }

  @override
  Future<Either> fetchPlaylistsFromFirestore() async {
    try {
      final userId = _authService.getCurrentUserId();
      if (userId == null) return Left('User not logged in');

      final snapshot =
          await _firestore
              .collection('users')
              .doc(userId)
              .collection('generated_playlists')
              .get();

      final playlists =
          snapshot.docs.map((doc) {
            final model = PlaylistModel.fromJson(doc.data());
            return model.toEntity();
          }).toList();

      return Right(playlists);
    } catch (e) {
      return Left('Failed to fetch playlists: $e');
    }
  }

  @override
  Future<Either> uploadGeneratePlaylists(List<String> genres) async {
    try {
      final userId = _authService.getCurrentUserId();
      if (userId == null) return Left('User not logged in');

      final uri = Uri.parse('${Baseurl.baseUrl}generate_playlists_by_genres');
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'genres': genres}),
      );

      if (response.statusCode != 200) {
        return Left('API error: ${response.statusCode}');
      }

      final List<dynamic> rawPlaylists = jsonDecode(response.body);
      final List<PlaylistEntity> playlists =
          rawPlaylists.map((e) {
            final List<SongEntity> songs =
                (e['songs'] as List)
                    .map((s) => SongModel.fromJson(s).toEntity())
                    .toList();
            final genre = e['genre'];

            // Chọn random template từ map
            final templates = genrePlaylistsMap[genre] ?? [];
            final template =
                templates.isNotEmpty
                    ? templates[Random().nextInt(templates.length)]
                    : null;

            return PlaylistEntity(
              id: e['id'],
              name: e['name'],
              genre: genre,
              image: template?.imageUrl ?? '',
              songs: songs,
            );
          }).toList();

      // Upload playlists lên Firestore
      final playlistCollection = _firestore
          .collection('users')
          .doc(userId)
          .collection('generated_playlists');

      for (final playlist in playlists) {
        await playlistCollection.doc(playlist.id).set({
          'id': playlist.id,
          'name': playlist.name,
          'genre': playlist.genre,
          'image': playlist.image,
          'songs':
              playlist.songs
                  .map((song) => SongModelX.fromEntity(song).toJson())
                  .toList(),
        });
      }

      return const Right(null);
    } catch (e) {
      return Left('Unexpected error: $e');
    }
  }
}
