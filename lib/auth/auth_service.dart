import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  AuthService._();

  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static User? get currentUser => _auth.currentUser;

  static Future<bool> loginAdmin(String email, String password) async {
    final UserCredential credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return credential.user != null;
  }

  static Future<void> logout() {
    return _auth.signOut();
  }
}
