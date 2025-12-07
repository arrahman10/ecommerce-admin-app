import 'package:ecommerce_admin_app/models/product.dart';

double calculateFinalPrice(Product product) {
  final double salePrice = product.salePrice;
  final double discount = product.discount;

  if (discount <= 0) {
    return salePrice;
  }

  final double discountedPrice = salePrice * (1 - discount / 100);
  return discountedPrice;
}
