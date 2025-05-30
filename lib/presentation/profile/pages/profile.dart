import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:notspotify/core/config/theme/app_colors.dart';
import 'package:notspotify/core/routes/app_routes.dart';
import 'package:notspotify/domain/usecases/auth/get_user.dart';
import 'package:notspotify/presentation/profile/pages/edit_profile.dart';
import 'package:notspotify/service_locator.dart';
import 'package:dartz/dartz.dart' as dartz;
import 'package:notspotify/domain/entities/auth/user.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<dartz.Either<dynamic, dynamic>> _userFuture;
  final getUserUseCase = sl<GetUserUseCase>();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    setState(() {
      _userFuture = getUserUseCase.call();
    });
  }

  Future<void> _signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.signIn,
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
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      body: FutureBuilder<dartz.Either<dynamic, dynamic>>(
        future: _userFuture,
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
                        onTap: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) =>
                                      EditProfilePage(user: user as UserEntity),
                            ),
                          );
                          if (result == true) {
                            _loadUserData();
                          }
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
