import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

import 'package:ecommerce_admin_app/providers/category_provider.dart';
import 'package:ecommerce_admin_app/utils/widget_functions.dart';

class CategoryPage extends StatelessWidget {
  static const String routeName = 'categories';

  const CategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('All Categories')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddCategoryDialog(context),
        child: const Icon(Icons.add),
      ),
      body: Consumer<CategoryProvider>(
        builder:
            (BuildContext context, CategoryProvider provider, Widget? child) {
              if (provider.categoryList.isEmpty) {
                return const Center(child: Text('No category found'));
              }

              return ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                children: <Widget>[
                  Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: provider.categoryList.length,
                      separatorBuilder: (BuildContext context, int index) {
                        return Divider(
                          height: 1,
                          indent: 72,
                          endIndent: 0,
                          color: theme.dividerColor.withOpacity(0.4),
                        );
                      },
                      itemBuilder: (BuildContext context, int index) {
                        final category = provider.categoryList[index];
                        final int productCount = category.productCount;
                        final String subtitleText = productCount > 0
                            ? '$productCount products'
                            : 'No products yet';

                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          leading: CircleAvatar(
                            radius: 20,
                            backgroundColor: theme.colorScheme.primary
                                .withOpacity(0.08),
                            child: Icon(
                              Icons.category_outlined,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          title: Text(
                            category.name,
                            style: theme.textTheme.titleMedium,
                          ),
                          subtitle: Text(
                            subtitleText,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.textTheme.bodySmall?.color
                                  ?.withOpacity(0.7),
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
    );
  }

  Future<void> _showAddCategoryDialog(BuildContext context) async {
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
            'Add category',
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
                labelText: 'Category name',
                prefixIcon: Icon(Icons.category_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
              ),
              validator: (String? value) {
                final String trimmed = value?.trim() ?? '';
                if (trimmed.isEmpty) {
                  return 'Please enter a category name';
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
      final String value = controller.text.trim();
      if (value.isEmpty) return;

      EasyLoading.show(status: 'Please wait');
      try {
        await Provider.of<CategoryProvider>(
          context,
          listen: false,
        ).addCategory(value);
        EasyLoading.dismiss();
        showMsg(context, 'Category added');
      } catch (_) {
        EasyLoading.dismiss();
        showMsg(context, 'Failed to add category');
      }
    }
  }
}
