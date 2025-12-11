import 'package:flutter/foundation.dart' as flutter_foundation;
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:ecommerce_admin_app/db/db_helper.dart';
import 'package:ecommerce_admin_app/models/brand.dart';

/// Provider responsible for loading and exposing brands.
///
/// It subscribes to the `Brands` collection and keeps an in-memory list
/// of [Brand] models so the UI can reactively rebuild when data changes.
class BrandProvider with flutter_foundation.ChangeNotifier {
  /// Internal in-memory cache of all brands.
  final List<Brand> _brandList = <Brand>[];

  /// Public, read-only view over the cached brands.
  List<Brand> get brandList => List.unmodifiable(_brandList);

  /// Guard flag to ensure we attach the Firestore listener only once.
  bool _isListening = false;

  /// Create and persist a new brand document in Firestore.
  Future<void> addBrand(String name) {
    final Brand brand = Brand(name: name.trim());
    return DbHelper.addBrand(brand);
  }

  /// Begin listening to all brand documents from Firestore.
  ///
  /// The listener will keep [_brandList] in sync with the backend and
  /// notify listeners whenever a change is received.
  void getAllBrands() {
    if (_isListening) return;
    _isListening = true;

    DbHelper.getAllBrands().listen((
      QuerySnapshot<Map<String, dynamic>> snapshot,
    ) {
      final List<Brand> brands = snapshot.docs
          .map((QueryDocumentSnapshot<Map<String, dynamic>> doc) {
            return Brand.fromJson(doc.data());
          })
          .toList(growable: false);

      _brandList
        ..clear()
        ..addAll(brands);

      notifyListeners();
    });
  }
}
