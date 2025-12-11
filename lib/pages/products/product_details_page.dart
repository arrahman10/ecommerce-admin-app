import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'package:ecommerce_admin_app/db/db_helper.dart';
import 'package:ecommerce_admin_app/models/image_model.dart';
import 'package:ecommerce_admin_app/models/product.dart';
import 'package:ecommerce_admin_app/providers/product_provider.dart';
import 'package:ecommerce_admin_app/utils/constants.dart';
import 'package:ecommerce_admin_app/utils/price_utils.dart';
import 'package:ecommerce_admin_app/utils/widget_functions.dart';

/// Page that shows full details for a single product.
///
/// Displays main and additional images, pricing & stock summary, description,
/// availability flags, purchase-related actions (re-purchase, history)
/// and delete product.
class ProductDetailsPage extends StatefulWidget {
  /// Route name used with [GoRouter] navigation.
  static const String routeName = 'product-details';

  const ProductDetailsPage({super.key, required this.product});

  /// Product instance passed from the list or another page.
  final Product product;

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  /// Local product instance used to render the UI.
  ///
  /// This is kept in state so that changes to pricing, stock, availability
  /// or description can be reflected immediately without reloading the page.
  late Product _product;

  /// Controls whether the description card is expanded (show full text)
  /// or collapsed (show up to 5 lines).
  bool _isDescriptionExpanded = false;

  /// Shared [ImagePicker] instance for capturing or selecting images.
  final ImagePicker _imagePicker = ImagePicker();

  // ================== Lifecycle ==================

  @override
  void initState() {
    super.initState();
    _product = widget.product;
  }

  // ================== UI build ==================

  @override
  Widget build(BuildContext context) {
    final Product product = _product;

    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Delete product',
            onPressed: () => _confirmDeleteProduct(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildMainImage(context, product),
            const SizedBox(height: 12),
            _buildAdditionalImagesSection(context, product),
            const SizedBox(height: 8),
            _buildPrimaryActionsRow(context),
            const SizedBox(height: 20),
            _buildBasicInfoSection(context, product),
            const SizedBox(height: 12),
            _buildPriceAndStockSection(context, product),
            const SizedBox(height: 12),
            _buildDescriptionSection(context, product),
            const SizedBox(height: 12),
            _buildAvailabilitySection(context),
            const SizedBox(height: 20),
            _buildNotifyUsersButton(context),
          ],
        ),
      ),
    );
  }

  // ================== Main image ==================

  /// Build the main product image header.
  ///
  /// Uses [Product.imageUrl] or falls back to [Product.thumbnailUrl].
  /// If no image is available, shows a tappable placeholder to add one.
  Widget _buildMainImage(BuildContext context, Product product) {
    final ThemeData theme = Theme.of(context);
    final String? imageUrl = product.imageUrl?.isNotEmpty == true
        ? product.imageUrl
        : product.thumbnailUrl;

    if (imageUrl != null && imageUrl.isNotEmpty) {
      return GestureDetector(
        onTap: () => _showMainImagePreviewDialog(context, imageUrl),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                imageUrl,
                height: 325,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      );
    }

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => _showMainImageSourceSheet(context),
      child: Container(
        height: 350,
        width: double.infinity,
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withOpacity(0.04),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: theme.colorScheme.primary.withOpacity(0.5),
            width: 1,
          ),
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.add_a_photo_outlined,
              size: 40,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 8),
            Text(
              'Add product image',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Show a full-screen-style preview dialog for the main image.
  /// Top-left: close, top-right: delete.
  Future<void> _showMainImagePreviewDialog(
    BuildContext context,
    String imageUrl,
  ) async {
    final bool? shouldDelete = await showDialog<bool>(
      context: context,
      barrierColor: Colors.black87,
      builder: (BuildContext dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(16),
          child: Stack(
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  color: Colors.black,
                  child: InteractiveViewer(
                    child: Center(
                      child: Image.network(imageUrl, fit: BoxFit.contain),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 8,
                left: 8,
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.black54,
                  child: IconButton(
                    onPressed: () => Navigator.pop<bool>(dialogContext, false),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: const Icon(Icons.close, color: Colors.white),
                  ),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.redAccent,
                  child: IconButton(
                    onPressed: () => Navigator.pop<bool>(dialogContext, true),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: const Icon(Icons.delete_outline, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );

    if (shouldDelete == true) {
      if (!mounted) return;
      await _confirmDeleteMainImage(context);
    }
  }

  /// Bottom sheet to choose camera or gallery for the main product image.
  Future<void> _showMainImageSourceSheet(BuildContext parentContext) async {
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
                  _pickMainImage(parentContext, ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () {
                  Navigator.pop(sheetContext);
                  _pickMainImage(parentContext, ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  /// Pick a main image and upload/update it for the product.
  Future<void> _pickMainImage(BuildContext context, ImageSource source) async {
    final XFile? picked = await _imagePicker.pickImage(
      source: source,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 80,
    );

    if (picked == null) {
      return;
    }

    final String? productId = _product.id;
    if (productId == null || productId.isEmpty) {
      showMsg(context, 'Cannot update image: product id is missing');
      return;
    }

    try {
      EasyLoading.show(status: 'Updating image...');

      // Delete old main image file from Storage if any exists.
      if ((_product.imageUrl != null && _product.imageUrl!.isNotEmpty) ||
          (_product.thumbnailUrl != null &&
              _product.thumbnailUrl!.isNotEmpty)) {
        await DbHelper.deleteMainProductImageForProduct(_product);
      }

      // Upload new image.
      final ImageModel image = await DbHelper.uploadProductImage(
        File(picked.path),
      );

      // Update Firestore document with new image URLs.
      await FirebaseFirestore.instance
          .collection('Products')
          .doc(productId)
          .update(<String, Object?>{
            'imageUrl': image.downloadUrl,
            'thumbnailUrl': image.downloadUrl,
          });

      if (!mounted) return;

      setState(() {
        _product = _product.copyWith(
          imageUrl: image.downloadUrl,
          thumbnailUrl: image.downloadUrl,
        );
      });

      showMsg(context, 'Product image updated');
    } catch (e) {
      if (!mounted) return;
      showMsg(context, 'Failed to update product image: $e');
    } finally {
      EasyLoading.dismiss();
    }
  }

  /// Confirm and delete the main product image, then fall back to placeholder.
  Future<void> _confirmDeleteMainImage(BuildContext context) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Remove product image'),
          content: const Text(
            'Are you sure you want to remove the main product image?',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop<bool>(dialogContext, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop<bool>(dialogContext, true),
              child: const Text('Remove'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    if (!mounted) return;

    final String? productId = _product.id;
    if (productId == null || productId.isEmpty) {
      showMsg(context, 'Cannot remove image: product id is missing');
      return;
    }

    try {
      EasyLoading.show(status: 'Removing image...');

      // Delete existing main image file from Storage.
      await DbHelper.deleteMainProductImageForProduct(_product);

      // Clear image URLs on the product document.
      await FirebaseFirestore.instance
          .collection('Products')
          .doc(productId)
          .update(<String, Object?>{'imageUrl': null, 'thumbnailUrl': null});

      setState(() {
        _product = _product.copyWith(imageUrl: null, thumbnailUrl: null);
      });

      showMsg(context, 'Product image removed. You can add a new image.');
    } catch (e) {
      showMsg(context, 'Failed to remove product image: $e');
    } finally {
      EasyLoading.dismiss();
    }
  }

  // ================== Additional images ==================

  /// Section for managing additional product images (add, list, delete).
  Widget _buildAdditionalImagesSection(BuildContext context, Product product) {
    final String? productId = product.id;
    if (productId == null || productId.isEmpty) {
      // If there is no product id, skip additional images UI.
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

                            return GestureDetector(
                              onTap: () => _showAdditionalImagePreviewDialog(
                                context: context,
                                imageDocId: doc.id,
                                image: image,
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  image.downloadUrl,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
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

  /// Show preview dialog for an additional image with delete option.
  Future<void> _showAdditionalImagePreviewDialog({
    required BuildContext context,
    required String imageDocId,
    required ImageModel image,
  }) async {
    final bool? shouldDelete = await showDialog<bool>(
      context: context,
      barrierColor: Colors.black87,
      builder: (BuildContext dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(16),
          child: Stack(
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  color: Colors.black,
                  child: InteractiveViewer(
                    child: Center(
                      child: Image.network(
                        image.downloadUrl,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 8,
                left: 8,
                child: _buildOverlayIconButton(
                  context: dialogContext,
                  icon: Icons.close,
                  backgroundColor: Colors.black54,
                  iconColor: Colors.white,
                  onPressed: () => Navigator.pop<bool>(dialogContext, false),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: _buildOverlayIconButton(
                  context: dialogContext,
                  icon: Icons.delete_outline,
                  backgroundColor: Colors.redAccent,
                  iconColor: Colors.white,
                  onPressed: () => Navigator.pop<bool>(dialogContext, true),
                ),
              ),
            ],
          ),
        );
      },
    );

    if (shouldDelete == true) {
      if (!mounted) return;
      await _confirmDeleteAdditionalImage(
        context: context,
        imageDocId: imageDocId,
        image: image,
      );
    }
  }

  /// Reusable overlay icon button for image preview (close/delete).
  Widget _buildOverlayIconButton({
    required BuildContext context,
    required IconData icon,
    required Color backgroundColor,
    required Color iconColor,
    required VoidCallback onPressed,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: backgroundColor,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
      ),
    );
  }

  // ================== Primary actions (re-purchase / history) ==================

  /// Build the row with "Re-purchase" and "Purchase history" actions.
  /// Build the row with "Re-purchase" and "Purchase history" actions.
  ///
  /// Styled as two equally sized buttons with subtle elevation, so that
  /// it feels like a primary action block for this screen.
  Widget _buildPrimaryActionsRow(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => _showRepurchaseDialog(context),
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: theme.colorScheme.primary.withOpacity(0.06),
                foregroundColor: theme.colorScheme.primary,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              icon: const Icon(Icons.shopping_cart_outlined),
              label: const Text('Re-purchase'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () => _showPurchaseHistoryBottomSheet(context),
              style: OutlinedButton.styleFrom(
                foregroundColor: theme.colorScheme.primary,
                side: BorderSide(
                  color: theme.colorScheme.primary.withOpacity(0.7),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              icon: const Icon(Icons.history),
              label: const Text('Purchase history'),
            ),
          ),
        ],
      ),
    );
  }

  /// Dialog to handle re-purchase flow (quantity, price, optional note).
  ///
  /// The quantity and purchase price inputs are styled inside a single
  /// rounded card, similar to modern login forms.
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
        final ThemeData theme = Theme.of(dialogContext);

        return AlertDialog(
          title: const Text('Re-purchase product'),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 6,
                          ),
                          child: TextFormField(
                            controller: quantityController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              labelText: 'Quantity to purchase',
                              prefixIcon: Icon(Icons.shopping_cart_outlined),
                            ),
                            validator: (String? value) =>
                                _validateRequiredPositiveInt(
                                  value,
                                  'Quantity to purchase',
                                ),
                          ),
                        ),

                        // Divider(
                        //   height: 1,
                        //   color: theme.dividerColor.withOpacity(0.4),
                        // ),
                        Padding(
                          padding: const EdgeInsets.only(left: 56),
                          child: Divider(
                            height: 1,
                            color: theme.dividerColor.withOpacity(0.4),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 6,
                          ),
                          child: TextFormField(
                            controller: purchasePriceController,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              labelText: 'Purchase price (per unit)',
                              prefixIcon: Icon(Icons.attach_money_outlined),
                            ),
                            validator: (String? value) =>
                                _validateRequiredPositiveDouble(
                                  value,
                                  'Purchase price',
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: noteController,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      labelText: 'Note (optional)',
                      prefixIcon: Icon(Icons.note_alt_outlined),
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

      // Update local product state so the UI reflects new stock & price.
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

  /// Bottom sheet to show purchase history for this product.
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
                            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                            itemCount: docs.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 8),
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

                              return Card(
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  side: BorderSide(
                                    color: Theme.of(
                                      context,
                                    ).dividerColor.withOpacity(0.3),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 10,
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      const Padding(
                                        padding: EdgeInsets.only(top: 4),
                                        child: Icon(Icons.history, size: 20),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              '$quantity pcs × ৳${purchasePrice.toStringAsFixed(2)}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium
                                                  ?.copyWith(
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              'Total: ৳${totalCost.toStringAsFixed(2)}',
                                              style: Theme.of(
                                                context,
                                              ).textTheme.bodySmall,
                                            ),
                                            Text(
                                              'Date: $formattedDate',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall
                                                  ?.copyWith(
                                                    color: Theme.of(context)
                                                        .textTheme
                                                        .bodySmall
                                                        ?.color
                                                        ?.withOpacity(0.7),
                                                  ),
                                            ),
                                            if (note != null &&
                                                note.trim().isNotEmpty)
                                              Text(
                                                'Note: $note',
                                                style: Theme.of(
                                                  context,
                                                ).textTheme.bodySmall,
                                              ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
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

  // ================== Basic info ==================

  /// Build header section with name, category/brand and price summary.
  Widget _buildBasicInfoSection(BuildContext context, Product product) {
    final ThemeData theme = Theme.of(context);
    final double finalPrice = calculateFinalPrice(product);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      product.name,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${product.categoryName} • ${product.brandName}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.textTheme.bodyMedium?.color?.withOpacity(
                          0.8,
                        ),
                      ),
                    ),
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
                      style: theme.textTheme.bodySmall?.copyWith(
                        decoration: TextDecoration.lineThrough,
                      ),
                    )
                  else
                    const SizedBox(height: 4),
                  Text(
                    '৳${finalPrice.toStringAsFixed(0)}',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildShortDescriptionPreview(context, product),
        ],
      ),
    );
  }

  /// Short description preview under the header.
  Widget _buildShortDescriptionPreview(BuildContext context, Product product) {
    final ThemeData theme = Theme.of(context);
    final String? short = product.shortDescription?.trim();
    final String text = (short == null || short.isEmpty) ? '---' : short;

    return Text(
      text,
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
      style: theme.textTheme.bodyMedium,
    );
  }

  // ================== Price & stock summary ==================

  /// Show price & stock summary card and open edit dialog from here.
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

  /// Dialog to edit pricing and stock values.
  Future<void> _showEditPriceStockDialog(
    BuildContext context,
    Product product,
  ) async {
    final ThemeData theme = Theme.of(context);
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    // Prefill current values into the text fields.

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

    Widget _buildDialogField({
      required IconData icon,
      required String label,
      required TextEditingController controller,
      required TextInputType keyboardType,
      String? Function(String?)? validator,
    }) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            border: InputBorder.none,
            labelText: label,
            prefixIcon: Icon(icon),
          ),
        ),
      );
    }

    final bool? shouldSave = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Edit pricing & stock',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),

          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceVariant.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        _buildDialogField(
                          icon: Icons.shopping_bag_outlined,
                          label: 'Purchase price',
                          controller: purchasePriceController,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          validator: (String? value) =>
                              _validateRequiredPositiveDouble(
                                value,
                                'Purchase price',
                              ),
                        ),
                        const Divider(height: 1, indent: 56),
                        _buildDialogField(
                          icon: Icons.sell_outlined,
                          label: 'Sale price',
                          controller: salePriceController,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          validator: (String? value) =>
                              _validateRequiredPositiveDouble(
                                value,
                                'Sale price',
                              ),
                        ),
                        const Divider(height: 1, indent: 56),
                        _buildDialogField(
                          icon: Icons.percent,
                          label: 'Discount (%)',
                          controller: discountController,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          validator: (String? value) =>
                              _validateRequiredNonNegativeDouble(
                                value,
                                'Discount',
                              ),
                        ),
                        const Divider(height: 1, indent: 56),
                        _buildDialogField(
                          icon: Icons.inventory_2_outlined,
                          label: 'Quantity in stock',
                          controller: stockController,
                          keyboardType: TextInputType.number,
                          validator: (String? value) =>
                              _validateRequiredNonNegativeInt(
                                value,
                                'Quantity in stock',
                              ),
                        ),
                      ],
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

    // Parse new values.
    final double newPurchasePrice = double.parse(
      purchasePriceController.text.trim(),
    );
    final double newSalePrice = double.parse(salePriceController.text.trim());
    final double newDiscount = discountController.text.trim().isEmpty
        ? 0.0
        : double.parse(discountController.text.trim());
    final int newStock = int.parse(stockController.text.trim());

    // If nothing changed, do not hit Firestore.
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

      // Update local state so UI reflects immediately.
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

  // ================== Description ==================

  /// Description section that shows a preview and opens the full editor.
  Widget _buildDescriptionSection(BuildContext context, Product product) {
    final ThemeData theme = Theme.of(context);
    final String longText = product.longDescription?.trim() ?? '';
    final String shortText = product.shortDescription?.trim() ?? '';

    final String baseDescription = longText.isNotEmpty
        ? longText
        : (shortText.isNotEmpty ? shortText : 'No description added yet');
    final bool hasDescription = baseDescription != 'No description added yet';

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Description', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: theme.dividerColor.withOpacity(0.3)),
            ),
            child: Text(
              baseDescription,
              maxLines: _isDescriptionExpanded ? null : 5,
              overflow: _isDescriptionExpanded
                  ? TextOverflow.visible
                  : TextOverflow.ellipsis,

              style: theme.textTheme.bodyMedium,
            ),
          ),
          const SizedBox(height: 4),

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              if (hasDescription)
                TextButton(
                  onPressed: () {
                    setState(() {
                      _isDescriptionExpanded = !_isDescriptionExpanded;
                    });
                  },
                  child: Text(_isDescriptionExpanded ? 'See less' : 'See more'),
                ),
              TextButton(
                onPressed: () => _showDescriptionDialog(context, product),
                child: Text(
                  hasDescription ? 'Edit description' : 'Add description',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Dialog to view and edit the full long description.
  Future<void> _showDescriptionDialog(
    BuildContext context,
    Product product,
  ) async {
    final ProductProvider provider = context.read<ProductProvider>();

    final TextEditingController controller = TextEditingController(
      text: product.longDescription ?? '',
    );

    final String? updatedText = await showDialog<String>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Edit description',
            style: Theme.of(
              dialogContext,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),

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

    // If user cancels or keeps text unchanged, do nothing.
    if (updatedText == null || updatedText == product.longDescription?.trim()) {
      return;
    }

    try {
      EasyLoading.show(status: 'Saving description...');

      await provider.updateProductDescription(
        product: product,
        longDescription: updatedText.isEmpty ? null : updatedText,
      );

      if (mounted) {
        setState(() {
          _product = _product.copyWith(
            longDescription: updatedText.isEmpty ? null : updatedText,
          );
        });
      }

      EasyLoading.showSuccess('Description updated');
    } catch (e) {
      EasyLoading.showError('Failed to update description');
    }
  }

  // ================== Availability (Available / Featured) ==================

  /// Product availability (Available / Featured) section with switches.
  Widget _buildAvailabilitySection(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    BoxDecoration _tileDecoration() {
      return BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerColor.withOpacity(0.5)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      );
    }

    Widget _buildAvailabilityTile({
      required String label,
      required bool value,
      required ValueChanged<bool> onChanged,
    }) {
      return Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: _tileDecoration(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(label, style: theme.textTheme.bodyMedium),
            Switch(value: value, onChanged: onChanged),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Availability', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          _buildAvailabilityTile(
            label: 'Available',
            value: _product.available,
            onChanged: (bool value) {
              _updateAvailabilityAndFeatured(
                context: context,
                available: value,
                featured: _product.featured,
              );
            },
          ),
          _buildAvailabilityTile(
            label: 'Featured',
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
    );
  }

  /// Helper to update Available and Featured flags in Firestore and local state.
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
          // For debugging you can use debugPrint(e.toString()) instead of UI text.
          content: Text('Failed to update availability'),
        ),
      );
    }
  }

  // ================== Notify users (placeholder) ==================

  /// Placeholder action to notify users about this product.
  Widget _buildNotifyUsersButton(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Notify users feature will be implemented later.'),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: theme.colorScheme.onPrimary,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          'Notify users',
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.onPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  // ================== Validation helpers ==================

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
      // You can return null here if you want empty discount to be allowed.
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

  // ================== Additional image picking ==================

  /// Bottom sheet to choose camera or gallery for additional image.
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

  /// Pick an additional image and upload/save it for the product.
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
      EasyLoading.show(status: 'Uploading image...');

      await context.read<ProductProvider>().addAdditionalProductImage(
        product: _product,
        imageFile: File(picked.path),
      );

      if (!mounted) return;
      showMsg(context, 'Additional image added');
    } catch (e) {
      if (!mounted) return;
      showMsg(context, 'Failed to add additional image: $e');
    } finally {
      EasyLoading.dismiss();
    }
  }

  /// Show confirm dialog before deleting an additional image.
  Future<void> _confirmDeleteAdditionalImage({
    required BuildContext context,
    required String imageDocId,
    required ImageModel image,
  }) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Delete image'),
          content: const Text('Are you sure you want to delete this image?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop<bool>(dialogContext, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop<bool>(dialogContext, true),
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
      EasyLoading.show(status: 'Deleting image...');

      await context.read<ProductProvider>().deleteAdditionalProductImage(
        product: _product,
        imageDocId: imageDocId,
        image: image,
      );

      showMsg(context, 'Additional image deleted');
    } catch (e) {
      showMsg(context, 'Failed to delete additional image: $e');
    } finally {
      EasyLoading.dismiss();
    }
  }

  // ================== Product delete ==================

  /// Show confirmation dialog before deleting the product.
  Future<void> _confirmDeleteProduct(BuildContext context) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Delete product'),
          content: Text('Are you sure you want to delete "${_product.name}"?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    final ProductProvider provider = context.read<ProductProvider>();

    try {
      await provider.deleteProduct(product: _product);

      if (!mounted) {
        return;
      }

      // Show success message first, then go back to the list.
      showMsg(context, 'Product deleted successfully');
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) {
        return;
      }
      showMsg(context, 'Failed to delete product: $e');
    }
  }
}
