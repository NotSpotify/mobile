import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:notspotify/core/config/theme/app_theme.dart';
import 'package:notspotify/presentation/choose_mode/bloc/theme_cubit.dart';
import 'package:notspotify/presentation/splash/pages/splash.dart';
import 'package:path_provider/path_provider.dart';

Future<void> main() async {
  // initialize hydrated bloc
  WidgetsFlutterBinding.ensureInitialized();
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
      providers: [BlocProvider(create: (_) => ThemeCubit())],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder:
            (context, ThemeMode themeMode) => MaterialApp(
              home: SplashPage(),
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              debugShowCheckedModeBanner: false,
              themeMode: themeMode,
            ),
      ),
    );
  }
}
