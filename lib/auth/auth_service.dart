import 'package:firebase_auth/firebase_auth.dart';

import 'package:ecommerce_admin_app/db/db_helper.dart';

/// Authentication service for admin users.
///
/// Wraps [FirebaseAuth] and adds a helper to verify that a signed-in user
/// actually belongs to the Admins collection in Firestore.
class AuthService {
  /// Private constructor to prevent instantiation.
  AuthService._();

  /// Underlying FirebaseAuth instance used by this service.
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Returns the currently signed-in [User], or null if no user is authenticated.
  static User? get currentUser => _auth.currentUser;

  /// Sign in using email and password and verify that the user is an admin.
  ///
  /// Returns `true` only if:
  /// - Firebase sign-in succeeds, and
  /// - the user id exists in the Admins collection (checked via [DbHelper.isAdmin]).
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

  /// Sign out the current user.
  static Future<void> logout() {
    return _auth.signOut();
  }
}
