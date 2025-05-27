import 'package:notspotify/data/models/auth/user.dart';

class UserEntity {
  String? userId;
  String? fullName;
  String? email;
  String? imageUrl;
  bool? hasChosenGenre;
  List<String>? genrePreference;

  UserEntity({
    this.userId,
    this.fullName,
    this.email,
    this.imageUrl,
    this.hasChosenGenre,
    this.genrePreference,
  });
}

extension UserEntityX on UserEntity {
  UserModel toModel() {
    return UserModel(
      fullName: fullName,
      email: email,
      imageUrl: imageUrl,
      hasChosenGenre: hasChosenGenre,
      genrePreference: genrePreference,
    );
  }
}
