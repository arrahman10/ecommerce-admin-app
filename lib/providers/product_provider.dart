import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show ChangeNotifier;

import 'package:ecommerce_admin_app/db/db_helper.dart';
import 'package:ecommerce_admin_app/models/brand.dart';
import 'package:ecommerce_admin_app/models/category.dart';
import 'package:ecommerce_admin_app/models/image_model.dart';
import 'package:ecommerce_admin_app/models/product.dart';

/// Provider responsible for managing product-related state, including
/// the in-memory list, pricing updates, availability flags, and
/// purchase/additional image helpers.
class ProductProvider with ChangeNotifier {
  // ================== Core state ==================

  final List<Product> _productList = <Product>[];
  bool _isListening = false;
  bool _isLoading = false;

  /// Exposes an unmodifiable view of the in-memory product list so that
  /// outside widgets cannot mutate it directly.
  List<Product> get productList => List.unmodifiable(_productList);

  // ================== Product loading & realtime sync ==================

  /// Load all products from Firestore ordered by latest createdAt and keep
  /// the in-memory list in sync via a realtime listener.
  ///
  /// The listener is attached only once per provider instance, guarded by
  /// the [_isListening] flag.
  /// Whether the initial product stream is currently loading.
  bool get isLoading => _isLoading;

  /// Load all products from Firestore ordered by latest createdAt.
  void getAllProducts() {
    if (_isListening) return;
    _isListening = true;

    _isLoading = true;
    notifyListeners();

    DbHelper.getAllProducts().listen(
      (QuerySnapshot<Map<String, dynamic>> snapshot) {
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

        _isLoading = false;
        notifyListeners();
      },
      onError: (Object error, StackTrace stackTrace) {
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  // ================== Description updates ==================

  /// Update the long description of the given product in Firestore and keep
  /// the local product list in sync with the new value.
  Future<void> updateProductDescription({
    required Product product,
    required String? longDescription,
  }) async {
    final String? productId = product.id;
    if (productId == null || productId.isEmpty) {
      return;
    }

    // Update description in Firestore via DbHelper.
    await DbHelper.updateProductDescription(productId, longDescription);

    // Update the in-memory product list so UI stays in sync.
    final int index = _productList.indexWhere((Product p) => p.id == productId);
    if (index != -1) {
      _productList[index] = product.copyWith(longDescription: longDescription);
      notifyListeners();
    }
  }

  // ================== Pricing, stock & purchases ==================

  /// Update product pricing and stock while keeping category and brand
  /// productCount values in sync when the stock changes.
  Future<void> updateProductPricingAndStock({
    required Product product,
    required double purchasePrice,
    required double salePrice,
    required double discount,
    required int stock,
  }) async {
    if (product.id == null || product.id!.isEmpty) {
      throw StateError('Cannot update product without a valid id');
    }

    final int oldStock = product.stock;
    final int newStock = stock;
    final int deltaStock = newStock - oldStock;

    // Update product document in Firestore.
    await DbHelper.updateProductPricingAndStock(
      productId: product.id!,
      purchasePrice: purchasePrice,
      salePrice: salePrice,
      discount: discount,
      stock: newStock,
    );

    // Adjust category/brand productCount when stock changes.
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

    // Update the product inside local productList.
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

  /// High-level helper to add a purchase history entry and then reuse the
  /// pricing/stock update helper to increase the product stock.
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

    // Compute the new stock (old stock + newly purchased quantity).
    final int newStock = product.stock + quantity;

    // First, add a purchase record under the product.
    await DbHelper.addPurchase(
      productId: productId,
      quantity: quantity,
      purchasePrice: purchasePrice,
      note: note,
    );

    // Then reuse existing helper to update product document and local list.
    await updateProductPricingAndStock(
      product: product,
      purchasePrice: purchasePrice,
      salePrice: product.salePrice,
      discount: product.discount,
      stock: newStock,
    );
  }

  // ================== Availability & featured flags ==================

  /// Update product availability and featured flags in Firestore and keep
  /// the corresponding product in the local list in sync.
  Future<void> updateProductAvailabilityAndFeatured({
    required Product product,
    required bool available,
    required bool featured,
  }) async {
    final String? productId = product.id;
    if (productId == null || productId.isEmpty) {
      throw StateError('Cannot update product without a valid id');
    }

    // Update flags in Firestore.
    await DbHelper.updateProductAvailabilityAndFeatured(
      productId: productId,
      available: available,
      featured: featured,
    );

    // Update the matching product inside local productList.
    final int index = _productList.indexWhere((Product p) => p.id == productId);

    if (index != -1) {
      _productList[index] = product.copyWith(
        available: available,
        featured: featured,
      );
      notifyListeners();
    }
  }

  // ================== Product creation (with image) ==================

  /// Create a new product with its primary image by uploading the image
  /// file to Firebase Storage and then saving a Product document in Firestore.
  ///
  /// Category and brand productCount values are incremented by the initial
  /// stock quantity when it is greater than zero.
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
    // Upload image to Firebase Storage and get ImageModel.
    final ImageModel thumbnail = await DbHelper.uploadProductImage(imageFile);

    // Build Product instance.
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

    // Save product document.
    await DbHelper.addProduct(product);

    // Increment category & brand productCount by stock quantity.
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

  // ================== Additional product images ==================

  /// Upload and save an additional image for a product.
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

  /// Delete an additional image for a product from both Firestore and Storage.
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

  // ================== Product deletion & cleanup ==================

  /// Delete a product and clean up related data including:
  /// - category and brand productCount adjustments
  /// - all additional images (Storage + Firestore docs)
  /// - all purchase history entries
  /// - the main product image file
  /// - the main product document itself
  Future<void> deleteProduct({required Product product}) async {
    final String? productId = product.id;
    if (productId == null || productId.isEmpty) {
      throw StateError('Cannot delete product without a valid id');
    }

    // Decrement category/brand productCount by current stock.
    if (product.stock > 0) {
      if (product.categoryId.isNotEmpty) {
        await DbHelper.incrementCategoryProductCount(
          categoryId: product.categoryId,
          quantity: -product.stock,
        );
      }
      if (product.brandId.isNotEmpty) {
        await DbHelper.incrementBrandProductCount(
          brandId: product.brandId,
          quantity: -product.stock,
        );
      }
    }

    // Delete all additional images (Storage + Firestore docs).
    await DbHelper.deleteAllAdditionalProductImagesForProduct(productId);

    // Delete all purchase history entries.
    await DbHelper.deleteAllPurchasesForProduct(productId);

    // Delete the main product image file from Storage.
    await DbHelper.deleteMainProductImageForProduct(product);

    // Finally delete the main product document.
    await DbHelper.deleteProductDocument(productId);

    // Remove the product from the local list and notify listeners.
    _productList.removeWhere((Product p) => p.id == productId);
    notifyListeners();
  }
}
