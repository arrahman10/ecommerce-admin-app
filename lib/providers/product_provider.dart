import 'dart:io';

import 'package:flutter/foundation.dart' show ChangeNotifier;
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:ecommerce_admin_app/db/db_helper.dart';
import 'package:ecommerce_admin_app/models/brand.dart';
import 'package:ecommerce_admin_app/models/category.dart';
import 'package:ecommerce_admin_app/models/image_model.dart';
import 'package:ecommerce_admin_app/models/product.dart';

class ProductProvider with ChangeNotifier {
  final List<Product> _productList = <Product>[];
  bool _isListening = false;

  List<Product> get productList => List.unmodifiable(_productList);

  /// Load all products from Firestore ordered by latest createdAt.
  void getAllProducts() {
    if (_isListening) return;
    _isListening = true;

    DbHelper.getAllProducts().listen((
      QuerySnapshot<Map<String, dynamic>> snapshot,
    ) {
      final List<Product> products = snapshot.docs
          .map((QueryDocumentSnapshot<Map<String, dynamic>> doc) {
            final Map<String, dynamic> data = doc.data();

            // Ensure Firestore document id is reflected in the model as well.
            data[productFieldId] = doc.id;

            return Product.fromJson(data);
          })
          .toList(growable: false);

      _productList
        ..clear()
        ..addAll(products);

      notifyListeners();
    });
  }

  Future<void> updateProductDescription({
    required Product product,
    required String? longDescription,
  }) async {
    final String? productId = product.id;
    if (productId == null || productId.isEmpty) {
      return;
    }

    // update description in Firestore via DbHelper
    await DbHelper.updateProductDescription(productId, longDescription);

    // update the in-memory product list so UI stays in sync
    final int index = _productList.indexWhere((Product p) => p.id == productId);
    if (index != -1) {
      _productList[index] = product.copyWith(longDescription: longDescription);
      notifyListeners();
    }
  }

  /// Update product pricing and stock while keeping category/brand productCount in sync
  Future<void> updateProductPricingAndStock({
    required Product product,
    required double purchasePrice,
    required double salePrice,
    required double discount,
    required int stock,
  }) async {
    final int oldStock = product.stock;
    final int newStock = stock;
    final int deltaStock = newStock - oldStock;

    if (product.id == null || product.id!.isEmpty) {
      throw StateError('Cannot update product without a valid id');
    }

    // Update product document in Firestore
    await DbHelper.updateProductPricingAndStock(
      productId: product.id!,
      purchasePrice: purchasePrice,
      salePrice: salePrice,
      discount: discount,
      stock: newStock,
    );

    // Adjust category/brand productCount when stock changes
    if (deltaStock != 0) {
      if (product.categoryId.isNotEmpty) {
        await DbHelper.incrementCategoryProductCount(
          categoryId: product.categoryId,
          quantity: deltaStock,
        );
      }
      if (product.brandId.isNotEmpty) {
        await DbHelper.incrementBrandProductCount(
          brandId: product.brandId,
          quantity: deltaStock,
        );
      }
    }
    // Update the product inside local productList
    final int index = _productList.indexWhere(
      (Product p) => p.id == product.id,
    );
    if (index != -1) {
      _productList[index] = product.copyWith(
        purchasePrice: purchasePrice,
        salePrice: salePrice,
        discount: discount,
        stock: newStock,
      );
      notifyListeners();
    }
  }

  /// High-level helper to add purchase history and increase stock
  Future<void> addPurchaseAndIncreaseStock({
    required Product product,
    required int quantity,
    required double purchasePrice,
    String? note,
  }) async {
    final String? productId = product.id;
    if (productId == null || productId.isEmpty) {
      throw StateError('Cannot repurchase without a valid product id');
    }

    if (quantity <= 0) {
      throw ArgumentError.value(
        quantity,
        'quantity',
        'Quantity must be a positive integer',
      );
    }

    // Compute the new stock (old stock + newly purchased quantity)
    final int newStock = product.stock + quantity;

    // First, add a purchase record under the product
    await DbHelper.addPurchase(
      productId: productId,
      quantity: quantity,
      purchasePrice: purchasePrice,
      note: note,
    );

    // Then reuse existing helper to update product document and local list
    await updateProductPricingAndStock(
      product: product,
      purchasePrice: purchasePrice,
      salePrice: product.salePrice,
      discount: product.discount,
      stock: newStock,
    );
  }

  /// Update product availability and featured flags and keep local list in sync
  Future<void> updateProductAvailabilityAndFeatured({
    required Product product,
    required bool available,
    required bool featured,
  }) async {
    final String? productId = product.id;
    if (productId == null || productId.isEmpty) {
      throw StateError('Cannot update product without a valid id');
    }

    // Update flags in Firestore
    await DbHelper.updateProductAvailabilityAndFeatured(
      productId: productId,
      available: available,
      featured: featured,
    );

    // Update the matching product inside local productList
    final int index = _productList.indexWhere((Product p) => p.id == productId);

    if (index != -1) {
      _productList[index] = product.copyWith(
        available: available,
        featured: featured,
      );
      notifyListeners();
    }
  }

  Future<void> addProductWithImage({
    required File imageFile,
    DateTime? purchaseDate,
    required Category category,
    required Brand brand,
    required String name,
    String? shortDescription,
    String? longDescription,
    required double purchasePrice,
    required double salePrice,
    required int stock,
    double discount = 0.0,
  }) async {
    // Upload image to Firebase Storage and get ImageModel
    final ImageModel thumbnail = await DbHelper.uploadProductImage(imageFile);

    // Build Product instance
    final Product product = Product(
      imageUrl: thumbnail.downloadUrl,
      thumbnailUrl: thumbnail.downloadUrl,

      purchaseDate: purchaseDate ?? DateTime.now(),

      categoryId: category.id ?? '',
      categoryName: category.name,

      brandId: brand.id ?? '',
      brandName: brand.name,

      name: name.trim(),
      shortDescription: shortDescription?.trim(),
      longDescription: longDescription?.trim(),

      purchasePrice: purchasePrice,
      salePrice: salePrice,
      stock: stock,
      discount: discount,

      createdAt: DateTime.now(),
    );

    // Save product document
    await DbHelper.addProduct(product);

    // Increment category & brand productCount by stock quantity
    if (stock > 0) {
      if (category.id != null && category.id!.isNotEmpty) {
        await DbHelper.incrementCategoryProductCount(
          categoryId: category.id!,
          quantity: stock,
        );
      }
      if (brand.id != null && brand.id!.isNotEmpty) {
        await DbHelper.incrementBrandProductCount(
          brandId: brand.id!,
          quantity: stock,
        );
      }
    }
  }

  // Upload and save an additional image for a product
  Future<void> addAdditionalProductImage({
    required Product product,
    required File imageFile,
  }) async {
    if (product.id == null || product.id!.isEmpty) {
      throw StateError('Cannot add image for a product without a valid id');
    }

    final ImageModel image = await DbHelper.uploadProductImage(imageFile);

    await DbHelper.addAdditionalProductImage(
      productId: product.id!,
      image: image,
    );
  }

  // Delete an additional image for a product
  Future<void> deleteAdditionalProductImage({
    required Product product,
    required String imageDocId,
    required ImageModel image,
  }) async {
    if (product.id == null || product.id!.isEmpty) {
      throw StateError('Cannot delete image for a product without a valid id');
    }

    await DbHelper.deleteAdditionalProductImage(
      productId: product.id!,
      imageDocId: imageDocId,
      storagePath: image.storagePath,
    );
  }
}
