import 'package:flutter/material.dart';

import 'package:ecommerce_admin_app/models/product.dart';
import 'package:ecommerce_admin_app/utils/price_utils.dart';

class ProductDetailsPage extends StatefulWidget {
  static const String routeName = 'product-details';

  const ProductDetailsPage({super.key, required this.product});

  final Product product;

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  bool _available = true;
  bool _featured = false;

  @override
  Widget build(BuildContext context) {
    final Product product = widget.product;

    return Scaffold(
      appBar: AppBar(title: Text(product.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildMainImage(product),
            const SizedBox(height: 16),
            _buildAddImagesCard(context),
            const SizedBox(height: 12),
            _buildPrimaryActionsRow(context),
            const SizedBox(height: 24),
            _buildBasicInfoSection(context, product),
            const SizedBox(height: 16),
            _buildPriceAndStockSection(context, product),
            const SizedBox(height: 16),
            _buildDescriptionSection(context, product),
            const SizedBox(height: 16),
            _buildStatusSection(context),
            const SizedBox(height: 24),
            _buildNotifyUsersButton(context),
          ],
        ),
      ),
    );
  }

  // ---------- Header Image ----------

  Widget _buildMainImage(Product product) {
    final String? imageUrl = product.imageUrl?.isNotEmpty == true
        ? product.imageUrl
        : product.thumbnailUrl;

    if (imageUrl != null && imageUrl.isNotEmpty) {
      return Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            imageUrl,
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
      );
    }

    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.center,
      child: Icon(Icons.image, size: 64, color: Colors.grey.shade500),
    );
  }

  // ---------- Add other images ----------

  Widget _buildAddImagesCard(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Additional images management will be added later.',
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Row(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.add, size: 24),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text('Add other images', style: TextStyle(fontSize: 16)),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }

  // ---------- Re-purchase / Purchase history buttons ----------

  Widget _buildPrimaryActionsRow(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Re-purchase flow will be added later.'),
                ),
              );
            },
            child: const Text('Re-purchase'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Purchase history will be added later.'),
                ),
              );
            },
            child: const Text('Purchase history'),
          ),
        ),
      ],
    );
  }

  // ---------- Basic info (name, category, brand) ----------

  Widget _buildBasicInfoSection(BuildContext context, Product product) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  product.name,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 4),
                Text(
                  product.categoryName,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  product.brandName,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                if (product.shortDescription != null &&
                    product.shortDescription!.trim().isNotEmpty) ...<Widget>[
                  const SizedBox(height: 8),
                  Text(
                    product.shortDescription!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              if (product.discount > 0)
                Text(
                  '৳${product.salePrice.toStringAsFixed(0)}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    decoration: TextDecoration.lineThrough,
                  ),
                )
              else
                const SizedBox(height: 4),
              Text(
                '৳${calculateFinalPrice(product).toStringAsFixed(0)}',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---------- Price & stock summary ----------

  Widget _buildPriceAndStockSection(BuildContext context, Product product) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(
                  'Sale price: ৳${product.salePrice.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const Spacer(),
                Text(
                  'Stock: ${product.stock}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Purchase price: ৳${product.purchasePrice.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 4),
            Text(
              product.discount > 0
                  ? 'Discount: ${product.discount.toStringAsFixed(1)}%'
                  : 'No discount applied',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  // ---------- Description (read-only for now) ----------

  Widget _buildDescriptionSection(BuildContext context, Product product) {
    final String description =
        (product.longDescription?.trim().isNotEmpty ?? false)
        ? product.longDescription!.trim()
        : (product.shortDescription?.trim().isNotEmpty ?? false)
        ? product.shortDescription!.trim()
        : 'No description added';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Description', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            description,
            maxLines: 5,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(height: 4),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Description edit will be added later.'),
                ),
              );
            },
            child: const Text('Show full description'),
          ),
        ),
      ],
    );
  }

  // ---------- Available / Featured switches (UI only) ----------

  Widget _buildStatusSection(BuildContext context) {
    return Column(
      children: <Widget>[
        SwitchListTile(
          title: const Text('Available'),
          value: _available,
          onChanged: (bool value) {
            setState(() {
              _available = value;
            });
          },
        ),
        SwitchListTile(
          title: const Text('Featured'),
          value: _featured,
          onChanged: (bool value) {
            setState(() {
              _featured = value;
            });
          },
        ),
      ],
    );
  }

  // ---------- Notify users button (placeholder) ----------

  Widget _buildNotifyUsersButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Notify users feature will be added later.'),
            ),
          );
        },
        child: const Text('Notify users'),
      ),
    );
  }
}
