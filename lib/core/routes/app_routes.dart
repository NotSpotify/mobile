import 'package:flutter/material.dart';
import 'package:notspotify/presentation/auth/pages/sign_in.dart';
import 'package:notspotify/presentation/auth/pages/sign_up.dart';
import 'package:notspotify/presentation/choose_mode/pages/mode.dart';
import 'package:notspotify/presentation/genre/pages/gerne_screen.dart';
import 'package:notspotify/presentation/home/pages/home.dart';
import 'package:notspotify/presentation/intro/pages/get_started.dart';
import 'package:notspotify/presentation/splash/pages/splash.dart';


class AppRoutes {
  static const splash = '/splash';
  static const getStarted = '/get-started';
  static const signIn = '/sign-in';
  static const signUp = '/sign-up';
  static const chooseMode = '/choose-mode';
  static const genre = '/genre';
  static const home = '/home';
  static const favourite = '/favourite';
  static const search = '/search';
  static const profile = '/profile';

  static Map<String, WidgetBuilder> routes = {
    splash: (_) => const SplashPage(),
    getStarted: (_) => const GetStartedPages(),
    signIn: (_) => const SignInPage(),
    signUp: (_) => const SignUpPage(),
    chooseMode: (_) => const ChooseModePage(),
    genre: (_) => const GenreSelectionPage(),
    home: (_) => const HomePage(),
  };
}
