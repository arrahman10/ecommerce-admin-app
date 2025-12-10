import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:ecommerce_admin_app/models/product.dart';
import 'package:ecommerce_admin_app/pages/products/product_details_page.dart';
import 'package:ecommerce_admin_app/providers/product_provider.dart';
import 'package:ecommerce_admin_app/utils/price_utils.dart';

class ViewProductPage extends StatefulWidget {
  static const String routeName = 'view-products';

  const ViewProductPage({super.key});

  @override
  State<ViewProductPage> createState() => _ViewProductPageState();
}

class _ViewProductPageState extends State<ViewProductPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().getAllProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Products')),
      body: Consumer<ProductProvider>(
        builder:
            (BuildContext context, ProductProvider provider, Widget? child) {
              final List<Product> products = provider.productList;

              if (products.isEmpty) {
                return const Center(child: Text('No products found'));
              }

              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: products.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (BuildContext context, int index) {
                  final Product product = products[index];
                  final double finalPrice = calculateFinalPrice(product);

                  return Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        context.pushNamed(
                          ProductDetailsPage.routeName,
                          extra: product,
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: <Widget>[
                            _buildThumbnail(context, product),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    product.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Stock: ${product.stock}',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.textTheme.bodySmall?.color
                                          ?.withOpacity(0.8),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                if (product.discount > 0)
                                  Text(
                                    '৳${product.salePrice.toStringAsFixed(0)}',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ),
                                if (product.discount > 0)
                                  const SizedBox(height: 2),
                                Text(
                                  '৳${finalPrice.toStringAsFixed(0)}',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
      ),
    );
  }

  Widget _buildThumbnail(BuildContext context, Product product) {
    final ThemeData theme = Theme.of(context);

    if (product.thumbnailUrl != null && product.thumbnailUrl!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          product.thumbnailUrl!,
          width: 56,
          height: 56,
          fit: BoxFit.cover,
        ),
      );
    }

    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.center,
      child: Icon(
        Icons.image_outlined,
        color: theme.colorScheme.primary,
        size: 28,
      ),
    );
  }
}
