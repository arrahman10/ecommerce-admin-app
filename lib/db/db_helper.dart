import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:ecommerce_admin_app/models/brand.dart';
import 'package:ecommerce_admin_app/models/category.dart';
import 'package:ecommerce_admin_app/models/image_model.dart';
import 'package:ecommerce_admin_app/models/product.dart';
import 'package:ecommerce_admin_app/utils/constants.dart';

class DbHelper {
  DbHelper._();

  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static const String collectionAdmins = 'Admins';
  static const String collectionBrand = 'Brands';
  static const String collectionCategory = 'Categories';

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
    final Brand brandWithId = brand.copyWith(id: doc.id);
    await doc.set(brandWithId.toJson());
  }

  /// Listen to all brands as a realtime stream.
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllBrands() {
    return _db.collection(collectionBrand).snapshots();
  }

  /// Add a new category document to the Categories collection.
  static Future<void> addCategory(Category category) async {
    final DocumentReference<Map<String, dynamic>> doc = _db
        .collection(collectionCategory)
        .doc();
    final Category categoryWithId = category.copyWith(id: doc.id);
    await doc.set(categoryWithId.toJson());
  }

  /// Listen to all categories as a realtime stream.
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllCategories() {
    return _db.collection(collectionCategory).snapshots();
  }

  /// Add a new product document to the Products collection.
  static Future<void> addProduct(Product product) async {
    final DocumentReference<Map<String, dynamic>> doc = _db
        .collection(collectionProduct)
        .doc();

    final Product updatedProduct = product.copyWith(
      id: doc.id,
      createdAt: product.createdAt ?? DateTime.now(),
    );

    await doc.set(updatedProduct.toJson());
  }

  /// Listen to all products as a realtime stream.
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllProducts() {
    return _db.collection(collectionProduct).snapshots();
  }

  /// Upload a single product image file to Firebase Storage
  /// and return an ImageModel with download URL + storage path.
  static Future<ImageModel> uploadProductImage(File file) async {
    final String originalFileName = file.uri.pathSegments.isNotEmpty
        ? file.uri.pathSegments.last
        : 'product_image.jpg';

    final String fileName =
        '${DateTime.now().millisecondsSinceEpoch}_$originalFileName';

    // Example: 'product_images/170170170_product_image.jpg'
    final String storagePath = '$storageFolderProductImages/$fileName';

    final Reference ref = FirebaseStorage.instance.ref().child(storagePath);

    final UploadTask uploadTask = ref.putFile(file);
    final TaskSnapshot snapshot = await uploadTask.whenComplete(() {});

    final String downloadUrl = await snapshot.ref.getDownloadURL();

    return ImageModel(
      downloadUrl: downloadUrl,
      storagePath: storagePath,
      uploadedAt: DateTime.now(),
    );
  }

  /// Increment total product quantity for a given category document.
  static Future<void> incrementCategoryProductCount({
    required String categoryId,
    required int quantity,
  }) async {
    if (quantity <= 0) return;

    final DocumentReference<Map<String, dynamic>> doc = _db
        .collection(collectionCategory)
        .doc(categoryId);

    await doc.update(<String, Object?>{
      categoryFieldProductCount: FieldValue.increment(quantity),
    });
  }

  /// Increment total product quantity for a given brand document.
  static Future<void> incrementBrandProductCount({
    required String brandId,
    required int quantity,
  }) async {
    if (quantity <= 0) return;

    final DocumentReference<Map<String, dynamic>> doc = _db
        .collection(collectionBrand)
        .doc(brandId);

    await doc.update(<String, Object?>{
      brandFieldProductCount: FieldValue.increment(quantity),
    });
  }
}
