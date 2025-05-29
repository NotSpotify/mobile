import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notspotify/common/widgets/button/basic_app_button.dart';
import 'package:notspotify/presentation/genre/bloc/gerne_cubit.dart';
import 'package:notspotify/service_locator.dart';
import 'package:notspotify/domain/usecases/user/upload_generate_playlist.dart';

final genreList = [
  {'label': 'Chill', 'icon': Icons.spa},
  {'label': 'Dance', 'icon': Icons.directions_run},
  {'label': 'Acoustic', 'icon': Icons.music_note},
  {'label': 'Energetic', 'icon': Icons.flash_on},
  {'label': 'Emotional', 'icon': Icons.favorite},
  {'label': 'Experimental', 'icon': Icons.auto_awesome},
];

class GenreSelectionPage extends StatelessWidget {
  const GenreSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Which genres do you enjoy?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: BlocBuilder<GenreSelectionCubit, Set<String>>(
                    builder: (context, selectedGenres) {
                      return GridView.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        children:
                            genreList.map((genre) {
                              final label = genre['label'] as String;
                              final icon = genre['icon'] as IconData;
                              final isSelected = selectedGenres.contains(label);

                              return GestureDetector(
                                onTap:
                                    () => context
                                        .read<GenreSelectionCubit>()
                                        .toggleGenre(label),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color:
                                        isSelected
                                            ? Colors.purpleAccent
                                            : Colors.grey[900],
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow:
                                        isSelected
                                            ? [
                                              BoxShadow(
                                                color: Colors.purpleAccent
                                                    .withOpacity(0.5),
                                                blurRadius: 10,
                                                spreadRadius: 2,
                                              ),
                                            ]
                                            : [],
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(icon, size: 40, color: Colors.white),
                                      const SizedBox(height: 10),
                                      Text(
                                        label,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                      );
                    },
                  ),
                ),
                BasicAppButton(
                  onPressed: () async {
                    final userId = FirebaseAuth.instance.currentUser?.uid;
                    final cubit = context.read<GenreSelectionCubit>();
                    final selectedGenres = cubit.state.toList();

                    if (userId == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('User not found.')),
                      );
                      return;
                    }

                    if (selectedGenres.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please select at least one genre.'),
                        ),
                      );
                      return;
                    }

                    // Step 1: Save genres
                    final result = await cubit.save(userId, selectedGenres);
                    if (result.isLeft()) {
                      final error = result.swap().getOrElse(() => "Unknown");
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Save failed: $error")),
                      );
                      return;
                    }

                    // Step 2: Auto-generate and upload playlists via API
                    final generateResult =
                        await sl<UploadGeneratePlaylistsUseCase>().call(
                          params: selectedGenres,
                        );

                    generateResult.fold(
                      (error) => ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Generate playlists failed: $error'),
                        ),
                      ),
                      (_) => Navigator.pushReplacementNamed(context, '/home'),
                    );
                  },
                  title: 'Continue',
                  color: Colors.green,
                  height: 55,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
