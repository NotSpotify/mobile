import 'package:notspotify/domain/entities/auth/user.dart';

class UserModel {
  String? fullName;
  String? email;
  String? imageUrl;


  UserModel({
    this.fullName,
    this.email,
    this.imageUrl,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    fullName = json['full_name'];
    email = json['email'];
    imageUrl = json['image_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['full_name'] = fullName;
    data['email'] = email;
    data['image_url'] = imageUrl;
    return data;
  }

  
}

extension UserModelX on UserModel {
  UserEntity toEntity() {
    return UserEntity(email: email, fullName: fullName, imageUrl: imageUrl);
  }
}
