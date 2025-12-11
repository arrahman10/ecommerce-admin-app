import 'package:flutter/foundation.dart' as flutter_foundation;
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:ecommerce_admin_app/db/db_helper.dart';
import 'package:ecommerce_admin_app/models/category.dart';

/// Provider responsible for loading and exposing product categories.
///
/// It subscribes to the `Categories` collection and keeps an in-memory list
/// of [Category] models so the UI can reactively rebuild when data changes.
class CategoryProvider with flutter_foundation.ChangeNotifier {
  /// Internal in-memory cache of all categories.
  final List<Category> _categoryList = <Category>[];

  /// Public, read-only view over the cached categories.
  List<Category> get categoryList => List.unmodifiable(_categoryList);

  /// Guard flag to ensure we attach the Firestore listener only once.
  bool _isListening = false;

  /// Create and persist a new category document in Firestore.
  Future<void> addCategory(String name) {
    final Category category = Category(name: name.trim());
    return DbHelper.addCategory(category);
  }

  /// Begin listening to all category documents from Firestore.
  ///
  /// The listener will keep [_categoryList] in sync with the backend and
  /// notify listeners whenever a change is received.
  void getAllCategories() {
    if (_isListening) return;
    _isListening = true;

    DbHelper.getAllCategories().listen((
      QuerySnapshot<Map<String, dynamic>> snapshot,
    ) {
      final List<Category> categories = snapshot.docs
          .map((QueryDocumentSnapshot<Map<String, dynamic>> doc) {
            return Category.fromJson(doc.data());
          })
          .toList(growable: false);

      _categoryList
        ..clear()
        ..addAll(categories);

      notifyListeners();
    });
  }
}
