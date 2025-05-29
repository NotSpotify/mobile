import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notspotify/data/sources/user/user_firebase_service.dart';
import 'package:notspotify/service_locator.dart';

class UserGenresCubit extends Cubit<List<String>> {
  final UserFirebaseService _userService = sl<UserFirebaseService>();

  UserGenresCubit() : super([]);

  Future<void> fetchGenres() async {
    final result = await _userService.getUserGenres();
    result.fold(
      (error) => emit([]), 
      (genres) => emit(genres),
    );
  }
}
