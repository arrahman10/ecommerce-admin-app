import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'package:ecommerce_admin_app/db/db_helper.dart';
import 'package:ecommerce_admin_app/models/image_model.dart';
import 'package:ecommerce_admin_app/models/product.dart';
import 'package:ecommerce_admin_app/providers/product_provider.dart';
import 'package:ecommerce_admin_app/utils/constants.dart';
import 'package:ecommerce_admin_app/utils/price_utils.dart';
import 'package:ecommerce_admin_app/utils/widget_functions.dart';

class ProductDetailsPage extends StatefulWidget {
  static const String routeName = 'product-details';

  const ProductDetailsPage({super.key, required this.product});

  final Product product;

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  // this is the local product instance shown in the UI
  late Product _product;
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _product = widget.product;
  }

  @override
  Widget build(BuildContext context) {
    final Product product = _product;

    return Scaffold(
      appBar: AppBar(title: Text(product.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildMainImage(product),
            const SizedBox(height: 16),
            _buildAdditionalImagesSection(context, product),
            const SizedBox(height: 12),
            _buildPrimaryActionsRow(context),
            const SizedBox(height: 24),
            _buildBasicInfoSection(context, product),
            const SizedBox(height: 16),
            _buildPriceAndStockSection(context, product),
            const SizedBox(height: 16),
            _buildDescriptionSection(context, product),
            const SizedBox(height: 16),
            _buildAvailabilitySection(context),
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

  // ---------- Additional images: list + add/delete ----------

  // Section for managing additional product images (add, list, delete)
  Widget _buildAdditionalImagesSection(BuildContext context, Product product) {
    final String? productId = product.id;
    if (productId == null || productId.isEmpty) {
      // If there is no product id, skip additional images UI
      return const SizedBox.shrink();
    }

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: DbHelper.getAdditionalProductImages(productId),
          builder:
              (
                BuildContext context,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot,
              ) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final List<QueryDocumentSnapshot<Map<String, dynamic>>> docs =
                    snapshot.data?.docs ??
                    <QueryDocumentSnapshot<Map<String, dynamic>>>[];

                final int imageCount = docs.length;
                final bool canAddMore = imageCount < 3;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Add other images',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        IconButton(
                          icon: const Icon(Icons.add_photo_alternate_outlined),
                          tooltip: canAddMore
                              ? 'Add additional image'
                              : 'Maximum 3 images allowed',
                          onPressed: canAddMore
                              ? () => _showAdditionalImageSourceSheet(context)
                              : () {
                                  showMsg(
                                    context,
                                    'You can add up to 3 additional images.',
                                  );
                                },
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (docs.isEmpty)
                      Text(
                        'No additional images yet.\nTap the plus icon to add.',
                        style: Theme.of(context).textTheme.bodySmall,
                      )
                    else
                      SizedBox(
                        height: 90,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: docs.length,
                          separatorBuilder: (_, __) => const SizedBox(width: 8),
                          itemBuilder: (BuildContext context, int index) {
                            final QueryDocumentSnapshot<Map<String, dynamic>>
                            doc = docs[index];
                            final ImageModel image = ImageModel.fromJson(
                              doc.data(),
                            );

                            return Stack(
                              children: <Widget>[
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    image.downloadUrl,
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                  top: 4,
                                  right: 4,
                                  child: InkWell(
                                    onTap: () => _confirmDeleteAdditionalImage(
                                      context: context,
                                      imageDocId: doc.id,
                                      image: image,
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black54,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      padding: const EdgeInsets.all(4),
                                      child: const Icon(
                                        Icons.close,
                                        size: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                  ],
                );
              },
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
            onPressed: () => _showRepurchaseDialog(context),

            child: const Text('Re-purchase'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton(
            onPressed: () => _showPurchaseHistoryBottomSheet(context),

            child: const Text('Purchase history'),
          ),
        ),
      ],
    );
  }

  // Dialog to handle re-purchase flow (quantity, price, note)
  Future<void> _showRepurchaseDialog(BuildContext context) async {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    final TextEditingController quantityController = TextEditingController(
      text: '',
    );
    final TextEditingController purchasePriceController = TextEditingController(
      text: _product.purchasePrice.toStringAsFixed(0),
    );
    final TextEditingController noteController = TextEditingController();

    final bool? shouldSave = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Re-purchase product'),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    controller: quantityController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Quantity to purchase',
                    ),
                    validator: (String? value) => _validateRequiredPositiveInt(
                      value,
                      'Quantity to purchase',
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: purchasePriceController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Purchase price (per unit)',
                    ),
                    validator: (String? value) =>
                        _validateRequiredPositiveDouble(
                          value,
                          'Purchase price',
                        ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: noteController,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      labelText: 'Note (optional)',
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (!formKey.currentState!.validate()) {
                  return;
                }
                Navigator.pop(dialogContext, true);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    if (shouldSave != true) {
      return;
    }

    final int quantity = int.parse(quantityController.text.trim());
    final double purchasePrice = double.parse(
      purchasePriceController.text.trim(),
    );
    final String? note = noteController.text.trim().isEmpty
        ? null
        : noteController.text.trim();

    final ProductProvider provider = context.read<ProductProvider>();

    try {
      await provider.addPurchaseAndIncreaseStock(
        product: _product,
        quantity: quantity,
        purchasePrice: purchasePrice,
        note: note,
      );

      if (!mounted) return;

      // Update local product state so the UI reflects new stock & price
      setState(() {
        _product = _product.copyWith(
          stock: _product.stock + quantity,
          purchasePrice: purchasePrice,
        );
      });

      showMsg(context, 'Purchase saved and stock updated');
    } catch (e) {
      if (!mounted) return;
      showMsg(context, 'Failed to complete re-purchase: $e');
    }
  }

  // Bottom sheet to show purchase history for this product
  Future<void> _showPurchaseHistoryBottomSheet(BuildContext context) async {
    final String? productId = _product.id;
    if (productId == null || productId.isEmpty) {
      showMsg(context, 'Cannot load purchase history: product id is missing');
      return;
    }

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext sheetContext) {
        return SafeArea(
          child: SizedBox(
            height: MediaQuery.of(sheetContext).size.height * 0.6,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Purchase history',
                        style: Theme.of(sheetContext).textTheme.titleMedium,
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(sheetContext),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: DbHelper.getPurchases(productId),
                    builder:
                        (
                          BuildContext context,
                          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                          snapshot,
                        ) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          final List<
                            QueryDocumentSnapshot<Map<String, dynamic>>
                          >
                          docs =
                              snapshot.data?.docs ??
                              <QueryDocumentSnapshot<Map<String, dynamic>>>[];

                          if (docs.isEmpty) {
                            return const Center(
                              child: Text('No purchase history yet.'),
                            );
                          }

                          return ListView.separated(
                            itemCount: docs.length,
                            separatorBuilder: (_, __) =>
                                const Divider(height: 1),
                            itemBuilder: (BuildContext context, int index) {
                              final Map<String, dynamic> data = docs[index]
                                  .data();

                              final int quantity =
                                  (data[purchaseFieldQuantity] as num?)
                                      ?.toInt() ??
                                  0;
                              final double purchasePrice =
                                  (data[purchaseFieldPurchasePrice] as num?)
                                      ?.toDouble() ??
                                  0.0;
                              final Timestamp ts =
                                  data[purchaseFieldPurchaseDate]
                                      as Timestamp? ??
                                  Timestamp.now();
                              final DateTime date = ts.toDate();
                              final String? note =
                                  data[purchaseFieldNote] as String?;

                              final String formattedDate =
                                  '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} '
                                  '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';

                              final double totalCost = quantity * purchasePrice;

                              return ListTile(
                                title: Text(
                                  '$quantity pcs × ৳${purchasePrice.toStringAsFixed(2)}',
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      'Total: ৳${totalCost.toStringAsFixed(2)}',
                                    ),
                                    Text('Date: $formattedDate'),
                                    if (note != null && note.trim().isNotEmpty)
                                      Text('Note: $note'),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                  ),
                ),
              ],
            ),
          ),
        );
      },
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

  // Show price & stock summary card and open edit dialog from here
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Price & stock',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  tooltip: 'Edit pricing and stock',
                  onPressed: () => _showEditPriceStockDialog(context, product),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Sale price: ৳${product.salePrice.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Purchase price: ৳${product.purchasePrice.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 4),
            Row(
              children: <Widget>[
                Text(
                  product.discount > 0
                      ? 'Discount: ${product.discount.toStringAsFixed(1)}%'
                      : 'No discount applied',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const Spacer(),
                Text(
                  'Stock: ${product.stock}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showEditPriceStockDialog(
    BuildContext context,
    Product product,
  ) async {
    // Separate form key for validation
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    // Prefill current values into the text fields
    final TextEditingController purchasePriceController = TextEditingController(
      text: _product.purchasePrice.toStringAsFixed(0),
    );
    final TextEditingController salePriceController = TextEditingController(
      text: _product.salePrice.toStringAsFixed(0),
    );
    final TextEditingController discountController = TextEditingController(
      text: _product.discount.toStringAsFixed(0),
    );
    final TextEditingController stockController = TextEditingController(
      text: _product.stock.toString(),
    );

    final bool? shouldSave = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Edit pricing & stock'),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    controller: purchasePriceController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Purchase price',
                    ),
                    validator: (String? value) =>
                        _validateRequiredPositiveDouble(
                          value,
                          'Purchase price',
                        ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: salePriceController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(labelText: 'Sale price'),
                    validator: (String? value) =>
                        _validateRequiredPositiveDouble(value, 'Sale price'),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: discountController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Discount (%)',
                    ),
                    validator: (String? value) =>
                        _validateRequiredNonNegativeDouble(value, 'Discount'),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: stockController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Quantity in stock',
                    ),
                    validator: (String? value) =>
                        _validateRequiredNonNegativeInt(
                          value,
                          'Quantity in stock',
                        ),
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (!formKey.currentState!.validate()) {
                  return;
                }
                Navigator.pop(dialogContext, true);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    if (shouldSave != true) {
      return;
    }

    // Parse new values
    final double newPurchasePrice = double.parse(
      purchasePriceController.text.trim(),
    );
    final double newSalePrice = double.parse(salePriceController.text.trim());
    final double newDiscount = discountController.text.trim().isEmpty
        ? 0.0
        : double.parse(discountController.text.trim());
    final int newStock = int.parse(stockController.text.trim());

    // If nothing changed, do not hit Firestore
    if (newPurchasePrice == _product.purchasePrice &&
        newSalePrice == _product.salePrice &&
        newDiscount == _product.discount &&
        newStock == _product.stock) {
      return;
    }

    final ProductProvider provider = context.read<ProductProvider>();

    try {
      await provider.updateProductPricingAndStock(
        product: _product,
        purchasePrice: newPurchasePrice,
        salePrice: newSalePrice,
        discount: newDiscount,
        stock: newStock,
      );

      if (!mounted) {
        return;
      }

      // Update local state so UI reflects immediately
      setState(() {
        _product = _product.copyWith(
          purchasePrice: newPurchasePrice,
          salePrice: newSalePrice,
          discount: newDiscount,
          stock: newStock,
        );
      });

      showMsg(context, 'Product pricing and stock updated');
    } catch (e) {
      if (!mounted) {
        return;
      }
      showMsg(context, 'Failed to update product: $e');
    }
  }

  // ---------- Description (read-only for now) ----------

  // this section shows description preview and triggers the full view/edit dialog
  Widget _buildDescriptionSection(BuildContext context, Product product) {
    final String longText = product.longDescription?.trim() ?? '';
    final String shortText = product.shortDescription?.trim() ?? '';

    // prefer longDescription, then shortDescription, otherwise show fallback text
    final String description = longText.isNotEmpty
        ? longText
        : (shortText.isNotEmpty ? shortText : 'No description added');

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
            onPressed: () => _showDescriptionDialog(context, product),
            child: const Text('Show full description'),
          ),
        ),
      ],
    );
  }

  Future<void> _showDescriptionDialog(
    BuildContext context,
    Product product,
  ) async {
    final ProductProvider provider = context.read<ProductProvider>();

    final TextEditingController controller = TextEditingController(
      text: product.longDescription ?? '',
    );

    // build a dialog to view and edit the full description
    final String? updatedText = await showDialog<String>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(product.name),
          content: SizedBox(
            width: double.infinity,
            child: TextField(
              controller: controller,
              maxLines: 15,
              decoration: const InputDecoration(
                labelText: 'Description',
                alignLabelWithHint: true,
                border: OutlineInputBorder(),
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(controller.text.trim());
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    // if user cancels or keeps text unchanged, do nothing
    if (updatedText == null || updatedText == product.longDescription?.trim()) {
      return;
    }

    // update new description in Firestore and in the local product list
    await provider.updateProductDescription(
      product: product,
      longDescription: updatedText.isEmpty ? null : updatedText,
    );

    // also update the local product state so the updated description appears immediately in the UI
    if (mounted) {
      setState(() {
        _product = _product.copyWith(
          longDescription: updatedText.isEmpty ? null : updatedText,
        );
      });
    }
  }

  // ---------- Available / Featured switches (UI only) ----------

  // Product availability (Available / Featured) section
  Widget _buildAvailabilitySection(BuildContext context) {
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
            Text(
              'Availability',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Available'),
              value: _product.available,
              onChanged: (bool value) {
                _updateAvailabilityAndFeatured(
                  context: context,
                  available: value,
                  featured: _product.featured,
                );
              },
            ),
            const SizedBox(height: 4),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Featured'),
              value: _product.featured,
              onChanged: (bool value) {
                _updateAvailabilityAndFeatured(
                  context: context,
                  available: _product.available,
                  featured: value,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // Helper to update Available and Featured flags in Firestore and local state
  Future<void> _updateAvailabilityAndFeatured({
    required BuildContext context,
    required bool available,
    required bool featured,
  }) async {
    final ProductProvider provider = context.read<ProductProvider>();

    try {
      await provider.updateProductAvailabilityAndFeatured(
        product: _product,
        available: available,
        featured: featured,
      );

      if (!mounted) return;

      setState(() {
        _product = _product.copyWith(available: available, featured: featured);
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          // For debugging you can use debugPrint(e.toString()) instead of UI text
          content: Text('Failed to update availability'),
        ),
      );
    }
  }

  // ---------- Notify users button (placeholder) ----------

  Widget _buildNotifyUsersButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          // future: add real notify users logic (e.g. send push or email)
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Notify users feature will be implemented later.'),
            ),
          );
        },
        child: const Text('Notify users'),
      ),
    );
  }

  String? _validateRequiredPositiveDouble(String? value, String fieldLabel) {
    final String trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return '$fieldLabel is required';
    }
    final double? parsed = double.tryParse(trimmed);
    if (parsed == null || parsed <= 0) {
      return '$fieldLabel must be a positive number';
    }
    return null;
  }

  String? _validateRequiredNonNegativeDouble(String? value, String fieldLabel) {
    final String trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      // You can return null here if you want empty discount to be allowed
      return null;
    }
    final double? parsed = double.tryParse(trimmed);
    if (parsed == null || parsed < 0) {
      return '$fieldLabel must be zero or a positive number';
    }
    return null;
  }

  String? _validateRequiredNonNegativeInt(String? value, String fieldLabel) {
    final String trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return '$fieldLabel is required';
    }
    final int? parsed = int.tryParse(trimmed);
    if (parsed == null || parsed < 0) {
      return '$fieldLabel must be zero or a positive integer';
    }
    return null;
  }

  String? _validateRequiredPositiveInt(String? value, String fieldLabel) {
    final String trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return '$fieldLabel is required';
    }
    final int? parsed = int.tryParse(trimmed);
    if (parsed == null || parsed <= 0) {
      return '$fieldLabel must be a positive integer';
    }
    return null;
  }

  // Bottom sheet to choose camera or gallery for additional image
  Future<void> _showAdditionalImageSourceSheet(
    BuildContext parentContext,
  ) async {
    await showModalBottomSheet<void>(
      context: parentContext,
      builder: (BuildContext sheetContext) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Capture image'),
                onTap: () {
                  Navigator.pop(sheetContext);
                  _pickAdditionalImage(parentContext, ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () {
                  Navigator.pop(sheetContext);
                  _pickAdditionalImage(parentContext, ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Pick an additional image and upload/save it for the product
  Future<void> _pickAdditionalImage(
    BuildContext context,
    ImageSource source,
  ) async {
    final XFile? picked = await _imagePicker.pickImage(
      source: source,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 80,
    );

    if (picked == null) {
      return;
    }

    if (_product.id == null || _product.id!.isEmpty) {
      showMsg(context, 'Cannot add image: product id is missing');
      return;
    }

    try {
      await context.read<ProductProvider>().addAdditionalProductImage(
        product: _product,
        imageFile: File(picked.path),
      );
      if (!mounted) return;
      showMsg(context, 'Additional image added');
    } catch (e) {
      if (!mounted) return;
      showMsg(context, 'Failed to add additional image: $e');
    }
  }

  // Show confirm dialog before deleting an additional image
  Future<void> _confirmDeleteAdditionalImage({
    required BuildContext context,
    required String imageDocId,
    required ImageModel image,
  }) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete image'),
          content: const Text('Are you sure you want to delete this image?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop<bool>(context, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop<bool>(context, true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    if (!mounted) return;

    try {
      await context.read<ProductProvider>().deleteAdditionalProductImage(
        product: _product,
        imageDocId: imageDocId,
        image: image,
      );
      showMsg(context, 'Additional image deleted');
    } catch (e) {
      showMsg(context, 'Failed to delete additional image: $e');
    }
  }
}
