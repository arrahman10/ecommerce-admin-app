import 'package:flutter/foundation.dart' as flutter_foundation;
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:ecommerce_admin_app/db/db_helper.dart';
import 'package:ecommerce_admin_app/models/category.dart';

class CategoryProvider with flutter_foundation.ChangeNotifier {
  List<Category> _categoryList = <Category>[];

  List<Category> get categoryList => _categoryList;

  bool _isListening = false;

  Future<void> addCategory(String name) {
    final Category category = Category(name: name.trim());
    return DbHelper.addCategory(category);
  }

  void getAllCategories() {
    if (_isListening) return;
    _isListening = true;

    DbHelper.getAllCategories().listen((
      QuerySnapshot<Map<String, dynamic>> snapshot,
    ) {
      _categoryList = snapshot.docs
          .map((QueryDocumentSnapshot<Map<String, dynamic>> doc) {
            return Category.fromJson(doc.data());
          })
          .toList(growable: false);

      notifyListeners();
    });
  }
}
