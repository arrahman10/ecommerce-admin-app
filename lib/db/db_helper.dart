import 'package:cloud_firestore/cloud_firestore.dart';

class DbHelper {
  DbHelper._();

  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static const String collectionAdmins = 'Admins';

  static Future<bool> isAdmin(String uid) async {
    final DocumentSnapshot<Map<String, dynamic>> snapshot = await _db
        .collection(collectionAdmins)
        .doc(uid)
        .get();
    return snapshot.exists;
  }
}
