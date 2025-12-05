import 'dart:io';

import 'package:flutter/foundation.dart' show ChangeNotifier;

import 'package:ecommerce_admin_app/db/db_helper.dart';
import 'package:ecommerce_admin_app/models/brand.dart';
import 'package:ecommerce_admin_app/models/category.dart';
import 'package:ecommerce_admin_app/models/image_model.dart';
import 'package:ecommerce_admin_app/models/product.dart';

class ProductProvider with ChangeNotifier {
  final List<Product> _productList = <Product>[];

  List<Product> get productList => List.unmodifiable(_productList);

  // future: loadProducts(), etc.

  Future<void> addProductWithImage({
    required File imageFile,
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
}
