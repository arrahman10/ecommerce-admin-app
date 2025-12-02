import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:ecommerce_admin_app/models/brand.dart';

class DbHelper {
  DbHelper._();

  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static const String collectionAdmins = 'Admins';

  /// Check if the given user id exists in the Admins collection.
  static Future<bool> isAdmin(String uid) async {
    final DocumentSnapshot<Map<String, dynamic>> snapshot = await _db
        .collection(collectionAdmins)
        .doc(uid)
        .get();
    return snapshot.exists;
  }

  /// Add a new brand document to the Brands collection.
  static Future<void> addBrand(Brand brand) async {
    final DocumentReference<Map<String, dynamic>> doc = _db
        .collection(collectionBrand)
        .doc();
    final Brand updatedBrand = brand.copyWith(id: doc.id);
    await doc.set(updatedBrand.toMap());
  }

  /// Listen to all brands as a realtime stream.
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllBrands() {
    return _db.collection(collectionBrand).snapshots();
  }
}
