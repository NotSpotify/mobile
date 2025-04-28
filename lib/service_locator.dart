import 'package:get_it/get_it.dart';
import 'package:notspotify/data/repository/auth/auth_repository_impl.dart';
import 'package:notspotify/data/sources/auth/auth_firebase_service.dart';
import 'package:notspotify/domain/repository/auth/auth_repo.dart';
import 'package:notspotify/domain/usecases/auth/get_user.dart';
import 'package:notspotify/domain/usecases/auth/signin.dart';
import 'package:notspotify/domain/usecases/auth/signin_google.dart';
import 'package:notspotify/domain/usecases/auth/signup.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  sl.registerSingleton<AuthFirebaseService>(AuthSupabaseServiceImpl());
  sl.registerSingleton<AuthRepo>(AuthRepositoryImpl());
  sl.registerSingleton<SignupUseCase>(SignupUseCase());
  sl.registerSingleton<SigninUseCase>(SigninUseCase());
  sl.registerSingleton<GetUserUseCase>(GetUserUseCase());
  sl.registerSingleton<SigninGoogleUseCase>(SigninGoogleUseCase());
}
