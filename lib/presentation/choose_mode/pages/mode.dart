import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:notspotify/common/widgets/button/basic_app_button.dart';
import 'package:notspotify/core/config/assets/app_images.dart';
import 'package:notspotify/core/config/assets/app_vectors.dart';
import 'package:notspotify/presentation/choose_mode/bloc/theme_cubit.dart';
import 'package:notspotify/presentation/home/pages/home.dart';

class ChooseModePage extends StatelessWidget {
  const ChooseModePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fitHeight,
                image: AssetImage(AppImages.intro2),
              ),
            ),
          ),
          Container(color: Colors.black.withOpacity(0.7)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 100),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: SvgPicture.asset(AppVectors.logo),
                ),
                const Spacer(),
                const Text(
                  'Choose your mode',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildThemeOption(
                      context: context,
                      icon: AppVectors.moon,
                      label: 'Dark',
                      themeMode: ThemeMode.dark,
                    ),
                    _buildThemeOption(
                      context: context,
                      icon: AppVectors.sun,
                      label: 'Light',
                      themeMode: ThemeMode.light,
                    ),
                  ],
                ),
                const SizedBox(height: 100),
                BasicAppButton(
                  title: "Continue",
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const HomePage()),
                    );
                  },
                  height: 70,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeOption({
    required BuildContext context,
    required String icon,
    required String label,
    required ThemeMode themeMode,
  }) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            context.read<ThemeCubit>().updateTheme(themeMode);
          },
          child: ClipOval(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: const Color(0xff30393C).withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: SvgPicture.asset(icon, fit: BoxFit.none),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 20,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
