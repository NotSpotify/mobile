import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:notspotify/core/config/theme/app_colors.dart';
import 'package:notspotify/domain/usecases/auth/get_user.dart';
import 'package:notspotify/service_locator.dart';
import 'package:notspotify/presentation/auth/pages/sign_in.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  Future<void> _signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const SignInPage()),
        (route) => false,
      );
    } catch (e) {
      print('Sign out error: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to sign out')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final getUserUseCase = sl<GetUserUseCase>();
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      body: FutureBuilder(
        future: getUserUseCase.call(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError || snapshot.data?.isLeft() == true) {
            return Center(child: Text('Failed to load profile'));
          } else {
            final user = snapshot.data!.fold((l) => null, (r) => r);
            if (user == null) {
              return const Center(child: Text('No user data'));
            }

            return Stack(
              children: [
                // Background Banner
                Container(
                  height: 250,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                        'assets/images/profile_banner.jpg',
                      ), // Placeholder banner
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // Nội dung
                SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 180),
                      Center(
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundImage: NetworkImage(
                                user.imageUrl ??
                                    'https://static.vecteezy.com/system/resources/previews/009/292/244/non_2x/default-avatar-icon-of-social-media-user-vector.jpg',
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              user.fullName ?? 'Your Name',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: primaryColor,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              user.email ?? 'your.email@example.com',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      _profileActionButton(
                        icon: Icons.edit,
                        title: 'Edit Profile',
                        onTap: () {
                          // TODO: Navigate to Edit Profile
                        },
                      ),
                      _profileActionButton(
                        icon: Icons.settings,
                        title: 'Settings',
                        onTap: () {
                          // TODO: Navigate to Settings
                        },
                      ),
                      _profileActionButton(
                        icon: Icons.logout,
                        title: 'Logout',
                        onTap: () => _signOut(context),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),

                // AppBar quay lại
              ],
            );
          }
        },
      ),
    );
  }

  Widget _profileActionButton({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
      child: Material(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        child: ListTile(
          leading: Icon(icon, color: AppColors.primary),
          title: Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: onTap,
        ),
      ),
    );
  }
}
