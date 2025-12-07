import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:ecommerce_admin_app/models/product.dart';
import 'package:ecommerce_admin_app/providers/product_provider.dart';

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
    return Scaffold(
      appBar: AppBar(title: const Text('Products')),
      body: Consumer<ProductProvider>(
        builder:
            (BuildContext context, ProductProvider provider, Widget? child) {
              final List<Product> products = provider.productList;

              if (products.isEmpty) {
                return const Center(child: Text('No products found'));
              }

              return ListView.builder(
                itemCount: products.length,
                itemBuilder: (BuildContext context, int index) {
                  final Product product = products[index];

                  return ListTile(
                    leading: _buildThumbnail(product),
                    title: Text(product.name),
                    subtitle: Text('Stock: ${product.stock}'),
                    trailing: Text(
                      '৳${product.salePrice.toStringAsFixed(0)}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    onTap: () {},
                  );
                },
              );
            },
      ),
    );
  }

  Widget _buildThumbnail(Product product) {
    if (product.thumbnailUrl != null && product.thumbnailUrl!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Image.network(
          product.thumbnailUrl!,
          width: 56,
          height: 56,
          fit: BoxFit.cover,
        ),
      );
    }

    return const Icon(Icons.image, size: 40);
  }
}
