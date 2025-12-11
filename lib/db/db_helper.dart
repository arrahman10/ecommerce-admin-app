import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:ecommerce_admin_app/models/brand.dart';
import 'package:ecommerce_admin_app/models/category.dart';
import 'package:ecommerce_admin_app/models/image_model.dart';
import 'package:ecommerce_admin_app/models/product.dart';
import 'package:ecommerce_admin_app/utils/constants.dart';

/// Helper class for all Firestore and Firebase Storage operations used by
/// the ecommerce admin app.
class DbHelper {
  DbHelper._();

  // ================== Core configuration & collection names ==================

  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static const String collectionAdmins = 'Admins';
  static const String collectionBrand = 'Brands';
  static const String collectionCategory = 'Categories';
  static const String subCollectionAdditionalImages = 'AdditionalImages';
  static const String subCollectionPurchases = 'Purchases';

  // ================== Admin helpers ==================

  /// Check if the given user id exists in the Admins collection.
  static Future<bool> isAdmin(String uid) async {
    final DocumentSnapshot<Map<String, dynamic>> snapshot = await _db
        .collection(collectionAdmins)
        .doc(uid)
        .get();
    return snapshot.exists;
  }

  // ================== Brand helpers ==================

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

  /// Increment total product quantity for a given brand document.
  ///
  /// If the provided quantity is zero, the method returns early without
  /// performing any update.
  static Future<void> incrementBrandProductCount({
    required String brandId,
    required int quantity,
  }) async {
    if (quantity == 0) {
      return;
    }

    final DocumentReference<Map<String, dynamic>> doc = _db
        .collection(collectionBrand)
        .doc(brandId);

    await doc.update(<String, Object?>{
      brandFieldProductCount: FieldValue.increment(quantity),
    });
  }

  // ================== Category helpers ==================

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

  /// Increment total product quantity for a given category document.
  ///
  /// If the provided quantity is zero, the method returns early without
  /// performing any update.
  static Future<void> incrementCategoryProductCount({
    required String categoryId,
    required int quantity,
  }) async {
    if (quantity == 0) {
      return;
    }

    final DocumentReference<Map<String, dynamic>> doc = _db
        .collection(collectionCategory)
        .doc(categoryId);

    await doc.update(<String, Object?>{
      categoryFieldProductCount: FieldValue.increment(quantity),
    });
  }

  // ================== Product images (upload & cleanup) ==================

  /// Upload a single product image file to Firebase Storage and return an
  /// [ImageModel] with download URL and storage path.
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

  /// Delete the main product image file from Firebase Storage if a URL is set.
  ///
  /// The method prefers [Product.imageUrl] and falls back to
  /// [Product.thumbnailUrl] when needed. Any storage errors are swallowed.
  static Future<void> deleteMainProductImageForProduct(Product product) async {
    final String? url = product.imageUrl?.isNotEmpty == true
        ? product.imageUrl
        : product.thumbnailUrl;

    if (url == null || url.isEmpty) {
      return;
    }

    try {
      final Reference ref = FirebaseStorage.instance.refFromURL(url);
      await ref.delete();
    } catch (_) {
      // Swallow errors to avoid breaking product deletion flows.
    }
  }

  // ================== Product CRUD & queries ==================

  /// Add a new product document to the Products collection.
  ///
  /// If [product.createdAt] is null, the current timestamp is used.
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

  /// Update product purchase price, sale price, discount and stock.
  static Future<void> updateProductPricingAndStock({
    required String productId,
    required double purchasePrice,
    required double salePrice,
    required double discount,
    required int stock,
  }) {
    return _db
        .collection(collectionProduct)
        .doc(productId)
        .update(<String, dynamic>{
          productFieldPurchasePrice: purchasePrice,
          productFieldSalePrice: salePrice,
          productFieldDiscount: discount,
          productFieldStock: stock,
        });
  }

  /// Update product availability and featured flags.
  static Future<void> updateProductAvailabilityAndFeatured({
    required String productId,
    required bool available,
    required bool featured,
  }) {
    return _db.collection(collectionProduct).doc(productId).update(
      <String, dynamic>{
        productFieldAvailable: available,
        productFieldFeatured: featured,
      },
    );
  }

  /// Listen to all products ordered by createdAt (latest first).
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllProducts() {
    return _db
        .collection(collectionProduct)
        .orderBy(productFieldCreatedAt, descending: true)
        .snapshots();
  }

  /// Update only the longDescription field for a given product document.
  static Future<void> updateProductDescription(
    String productId,
    String? longDescription,
  ) async {
    await _db.collection(collectionProduct).doc(productId).update(
      <String, dynamic>{productFieldLongDescription: longDescription},
    );
  }

  /// Delete a single product document from the Products collection.
  static Future<void> deleteProductDocument(String productId) {
    return _db.collection(collectionProduct).doc(productId).delete();
  }

  // ================== Additional images for products ==================

  /// Add an additional image for a product under its AdditionalImages
  /// sub-collection.
  static Future<void> addAdditionalProductImage({
    required String productId,
    required ImageModel image,
  }) async {
    await _db
        .collection(collectionProduct)
        .doc(productId)
        .collection(subCollectionAdditionalImages)
        .doc()
        .set(image.toJson());
  }

  /// Get a stream of all additional images for a product, ordered by upload
  /// time in descending order.
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAdditionalProductImages(
    String productId,
  ) {
    return _db
        .collection(collectionProduct)
        .doc(productId)
        .collection(subCollectionAdditionalImages)
        .orderBy('uploadedAt', descending: true)
        .snapshots();
  }

  /// Delete an additional image from both Firebase Storage and Firestore.
  static Future<void> deleteAdditionalProductImage({
    required String productId,
    required String imageDocId,
    required String storagePath,
  }) async {
    // Delete the storage file.
    final Reference ref = FirebaseStorage.instance.ref().child(storagePath);
    await ref.delete();

    // Delete the Firestore document.
    await _db
        .collection(collectionProduct)
        .doc(productId)
        .collection(subCollectionAdditionalImages)
        .doc(imageDocId)
        .delete();
  }

  /// Delete all additional images (Storage + Firestore docs) for a product.
  static Future<void> deleteAllAdditionalProductImagesForProduct(
    String productId,
  ) async {
    final QuerySnapshot<Map<String, dynamic>> snapshot = await _db
        .collection(collectionProduct)
        .doc(productId)
        .collection(subCollectionAdditionalImages)
        .get();

    for (final QueryDocumentSnapshot<Map<String, dynamic>> doc
        in snapshot.docs) {
      final ImageModel image = ImageModel.fromJson(doc.data());
      await deleteAdditionalProductImage(
        productId: productId,
        imageDocId: doc.id,
        storagePath: image.storagePath,
      );
    }
  }

  // ================== Purchase history for products ==================

  /// Add a new purchase entry under a product's Purchases sub-collection.
  ///
  /// The current timestamp is used as the purchase date. The note field is
  /// only written when a non-empty value is provided.
  static Future<void> addPurchase({
    required String productId,
    required int quantity,
    required double purchasePrice,
    String? note,
  }) async {
    await _db
        .collection(collectionProduct)
        .doc(productId)
        .collection(subCollectionPurchases)
        .add(<String, dynamic>{
          purchaseFieldQuantity: quantity,
          purchaseFieldPurchasePrice: purchasePrice,
          purchaseFieldPurchaseDate: DateTime.now(),
          if (note != null && note.trim().isNotEmpty)
            purchaseFieldNote: note.trim(),
        });
  }

  /// Get a stream of all purchase history entries for a product ordered by
  /// purchase date in descending order.
  static Stream<QuerySnapshot<Map<String, dynamic>>> getPurchases(
    String productId,
  ) {
    return _db
        .collection(collectionProduct)
        .doc(productId)
        .collection(subCollectionPurchases)
        .orderBy(purchaseFieldPurchaseDate, descending: true)
        .snapshots();
  }

  /// Delete all purchase history entries for a product.
  static Future<void> deleteAllPurchasesForProduct(String productId) async {
    final QuerySnapshot<Map<String, dynamic>> snapshot = await _db
        .collection(collectionProduct)
        .doc(productId)
        .collection(subCollectionPurchases)
        .get();

    for (final QueryDocumentSnapshot<Map<String, dynamic>> doc
        in snapshot.docs) {
      await doc.reference.delete();
    }
  }
}
