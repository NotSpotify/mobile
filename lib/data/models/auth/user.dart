import 'package:notspotify/domain/entities/auth/user.dart';

class UserModel {
  String? fullName;
  String? email;
  String? imageUrl;
  bool? hasChosenGenre;
  List<String>? genrePreference;

  UserModel({
    this.fullName,
    this.email,
    this.imageUrl,
    this.hasChosenGenre,
    this.genrePreference,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    fullName = json['full_name'];
    email = json['email'];
    imageUrl = json['image_url'];
    hasChosenGenre = json['has_chosen_genre'] ?? false;
    genrePreference =
        (json['genre_preference'] as List?)?.map((e) => e.toString()).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'full_name': fullName,
      'email': email,
      'image_url': imageUrl,
      'has_chosen_genre': hasChosenGenre ?? false,
      'genre_preference': genrePreference ?? [],
    };
  }
}
extension UserModelX on UserModel {
  UserEntity toEntity() {
    return UserEntity(
      email: email,
      fullName: fullName,
      imageUrl: imageUrl,
      hasChosenGenre: hasChosenGenre ?? false,
      genrePreference: genrePreference ?? [],
    );
  }
}
