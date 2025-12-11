import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

import 'package:ecommerce_admin_app/providers/brand_provider.dart';
import 'package:ecommerce_admin_app/utils/widget_functions.dart';

/// Page that shows all brands and allows the admin to add new brands.
///
/// Displays a list of brands with total product counts and uses
/// [BrandProvider] as the data source.
class BrandPage extends StatelessWidget {
  static const String routeName = 'brands';

  const BrandPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('All Brands')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddBrandDialog(context),
        child: const Icon(Icons.add),
      ),
      body: Consumer<BrandProvider>(
        builder: (BuildContext context, BrandProvider provider, Widget? child) {
          if (provider.brandList.isEmpty) {
            return const Center(child: Text('No brand found'));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: provider.brandList.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (BuildContext context, int index) {
              final brand = provider.brandList[index];
              final int productCount = brand.productCount;
              final String subtitleText = productCount > 0
                  ? 'Total products: $productCount'
                  : 'No products yet';

              return Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  leading: CircleAvatar(
                    radius: 18,
                    backgroundColor: theme.colorScheme.primary.withOpacity(
                      0.08,
                    ),
                    child: Icon(
                      Icons.star,
                      size: 22,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  title: Text(
                    brand.name,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  subtitle: Text(
                    subtitleText,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
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

  /// Show a dialog to create a new brand.
  ///
  /// Validates the brand name and then calls [BrandProvider.addBrand].
  Future<void> _showAddBrandDialog(BuildContext context) async {
    final ThemeData theme = Theme.of(context);
    final TextEditingController controller = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    final bool? shouldSave = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Add brand',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Form(
            key: formKey,
            child: TextFormField(
              controller: controller,
              autofocus: true,
              decoration: const InputDecoration(
                labelText: 'Brand name',
                prefixIcon: Icon(Icons.star_border),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
              ),
              validator: (String? value) {
                final String trimmed = value?.trim() ?? '';
                if (trimmed.isEmpty) {
                  return 'Please enter a brand name';
                }
                return null;
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
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

    if (shouldSave == true) {
      final String brandName = controller.text.trim();
      if (brandName.isEmpty) return;

      EasyLoading.show(status: 'Please wait');
      try {
        await context.read<BrandProvider>().addBrand(brandName);
        EasyLoading.dismiss();
        showMsg(context, 'Brand added');
      } catch (_) {
        EasyLoading.dismiss();
        showMsg(context, 'Failed to add brand');
      }
    }
  }
}
