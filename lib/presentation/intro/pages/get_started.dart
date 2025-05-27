import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:notspotify/common/widgets/button/basic_app_button.dart';
import 'package:notspotify/core/config/assets/app_images.dart';
import 'package:notspotify/core/config/assets/app_vectors.dart';
import 'package:notspotify/core/routes/app_routes.dart';

class GetStartedPages extends StatelessWidget {
  const GetStartedPages({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fitHeight,
                image: AssetImage(AppImages.intro1),
              ),
            ),
          ),

          Container(
            color: Colors.black.withValues(
              red: 0,
              green: 0,
              blue: 0,
              alpha: 0.7,
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 100),
            child: Center(
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: SvgPicture.asset(AppVectors.logo),
                  ),
                  Spacer(),
                  Text(
                    'Enjoy listening to your favorite music',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Discover new music and podcasts, and share them with your friends. Also, you can create your own playlists and listen to them offline.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 15,
                      color: Colors.grey[400],
                    ),
                  ),
                  SizedBox(height: 22),
                  BasicAppButton(
                    title: "Continue",
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                        context,
                        AppRoutes.chooseMode,
                      );
                    },
                    height: 70,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
