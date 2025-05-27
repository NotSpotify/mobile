import 'package:get_it/get_it.dart';
import 'package:notspotify/common/auth/auth_service.dart';
import 'package:notspotify/data/repository/auth/auth_repository_impl.dart';
import 'package:notspotify/data/repository/song/song_repository_impl.dart';
import 'package:notspotify/data/sources/auth/auth_firebase_service.dart';
import 'package:notspotify/data/sources/song/song_firebase_service.dart';
import 'package:notspotify/domain/repository/auth/auth_repo.dart';
import 'package:notspotify/domain/repository/song/song_repo.dart';
import 'package:notspotify/domain/usecases/auth/get_user.dart';
import 'package:notspotify/domain/usecases/auth/signin.dart';
import 'package:notspotify/domain/usecases/auth/signin_google.dart';
import 'package:notspotify/domain/usecases/auth/signup.dart';
import 'package:notspotify/domain/usecases/auth/update_genre_usecase.dart';
import 'package:notspotify/domain/usecases/song/add_recently.dart';
import 'package:notspotify/domain/usecases/song/add_to_favourite.dart';
import 'package:notspotify/domain/usecases/song/get_random_song.dart';
import 'package:notspotify/domain/usecases/song/recommend_song.dart';
import 'package:notspotify/domain/usecases/song/remove_from_favourite.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  sl.registerLazySingleton<AuthService>(() => AuthService());

  sl.registerSingleton<AuthFirebaseService>(AuthFirebaseServiceImpl());
  sl.registerSingleton<AuthRepo>(AuthRepositoryImpl());
  sl.registerSingleton<SongFirebaseService>(SongFirebaseServiceImpl());

  sl.registerSingleton<SignupUseCase>(SignupUseCase());
  sl.registerSingleton<SigninUseCase>(SigninUseCase());
  sl.registerSingleton<GetUserUseCase>(GetUserUseCase());
  sl.registerSingleton<SigninGoogleUseCase>(SigninGoogleUseCase());
  sl.registerSingleton<SongRepo>(SongRepositoryImpl());
  sl.registerSingleton<GetRandomSongUseCase>(GetRandomSongUseCase());
  sl.registerSingleton<RecommendSongUseCase>(RecommendSongUseCase());
  sl.registerSingleton<AddRecentlyUseCase>(AddRecentlyUseCase());
  sl.registerSingleton<RemoveFromFavouriteUseCase>(RemoveFromFavouriteUseCase());
  sl.registerSingleton<AddToFavouriteUseCase>(AddToFavouriteUseCase());
  sl.registerSingleton<UpdateGenreUseCase>(UpdateGenreUseCase());

}
