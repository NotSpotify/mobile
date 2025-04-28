abstract class SongFirebaseService {
  Future<void> addSongToFavourite(String spotifyId);
  Future<void> removeSongFromFavourite(String spotifyId);
  Future<List<String>> recommend(String spotifyId);
  Future<List<String>> getRandom(String spotifyId);
  Future<List<String>> searchSongs(String query);
}

class SongFirebaseServiceImpl extends SongFirebaseService {
  @override
  Future<void> addSongToFavourite(String spotifyId) async {
    // Implementation for adding a song to favourites in Firebase
  }

  @override
  Future<void> removeSongFromFavourite(String spotifyId) async {
    // Implementation for removing a song from favourites in Firebase
  }

  @override
  Future<List<String>> recommend(String spotifyId) async {
    // Implementation for recommending songs in Firebase
    return [];
  }

  @override
  Future<List<String>> getRandom(String spotifyId) async {
    // Implementation for getting random songs in Firebase
    return [];
  }

  @override
  Future<List<String>> searchSongs(String query) async {
    // Implementation for searching songs in Firebase
    return [];
  }
}