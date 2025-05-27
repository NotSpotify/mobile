import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:notspotify/core/config/assets/app_vectors.dart';
import 'package:notspotify/core/routes/app_routes.dart';
import 'package:notspotify/domain/usecases/auth/get_user.dart';
import 'package:notspotify/service_locator.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _handleRedirect();
  }

  Future<void> _handleRedirect() async {
    await Future.delayed(const Duration(milliseconds: 1500));

    if (!mounted) return;

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      Navigator.pushReplacementNamed(context, AppRoutes.getStarted);
      return;
    }

    final userResult = await sl<GetUserUseCase>().call();

    userResult.fold(
      (_) => Navigator.pushReplacementNamed(context, AppRoutes.getStarted),
      (user) {
        final route =
            user.hasChosenGenre == true ? AppRoutes.home : AppRoutes.genre;
        Navigator.pushReplacementNamed(context, route);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: SvgPicture.asset(AppVectors.logo)));
  }
}
