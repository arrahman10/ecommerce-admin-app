import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:ecommerce_admin_app/db/db_helper.dart';
import 'package:ecommerce_admin_app/models/brand.dart';

class BrandProvider with ChangeNotifier {
  List<Brand> _brandList = <Brand>[];

  List<Brand> get brandList => _brandList;

  bool _isListening = false;

  Future<void> addBrand(String name) {
    final Brand brand = Brand(name: name.trim());
    return DbHelper.addBrand(brand);
  }

  void getAllBrands() {
    if (_isListening) return;
    _isListening = true;

    DbHelper.getAllBrands().listen((
      QuerySnapshot<Map<String, dynamic>> snapshot,
    ) {
      _brandList = snapshot.docs
          .map((QueryDocumentSnapshot<Map<String, dynamic>> doc) {
            return Brand.fromJson(doc.data());
          })
          .toList(growable: false);

      notifyListeners();
    });
  }
}
