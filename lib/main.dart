import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:notspotify/core/config/theme/app_theme.dart';
import 'package:notspotify/core/routes/app_routes.dart';
import 'package:notspotify/firebase_options.dart';
import 'package:notspotify/presentation/choose_mode/bloc/theme_cubit.dart';
import 'package:notspotify/presentation/genre/bloc/gerne_cubit.dart';

import 'package:notspotify/presentation/home/bloc/now_playing_cubit.dart';
import 'package:notspotify/presentation/home/bloc/play_status.dart';

import 'package:notspotify/service_locator.dart';
import 'package:path_provider/path_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: "assets/.env");
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  //Initialize Supabase
  await initDependencies();
  // initialize hydrated bloc
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory:
        kIsWeb
            ? HydratedStorage.webStorageDirectory
            : await getApplicationDocumentsDirectory(),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ThemeCubit()),
        BlocProvider(create: (_) => NowPlayingCubit()),
        BlocProvider(create: (_) => PlayingStatusCubit()),
        BlocProvider(create: (_) => GenreSelectionCubit()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder:
            (context, ThemeMode themeMode) => MaterialApp(
              initialRoute: AppRoutes.splash,
              routes: AppRoutes.routes,
              debugShowCheckedModeBanner: false,
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: themeMode,
            ),
      ),
    );
  }
}
