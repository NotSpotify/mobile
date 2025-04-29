import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? getCurrentUserId() {
    final user = _auth.currentUser;
    return user?.uid;
  }
}
