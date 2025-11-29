import 'package:firebase_auth/firebase_auth.dart';
import 'package:ecommerce_admin_app/db/db_helper.dart';

class AuthService {
  AuthService._();

  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static User? get currentUser => _auth.currentUser;

  static Future<bool> loginAdmin(String email, String password) async {
    final UserCredential credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final User? user = credential.user;
    if (user == null) {
      return false;
    }

    return DbHelper.isAdmin(user.uid);
  }

  static Future<void> logout() {
    return _auth.signOut();
  }
}
