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
    return Scaffold(
      appBar: AppBar(title: const Text('All Categories')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showSingleTextInputDialog(
            context: context,
            title: 'Add Category',
            onSubmit: (String value) {
              if (value.trim().isEmpty) return;

              EasyLoading.show(status: 'Please wait');
              Provider.of<CategoryProvider>(context, listen: false)
                  .addCategory(value)
                  .then((_) {
                    EasyLoading.dismiss();
                    showMsg(context, 'Category added');
                  })
                  .catchError((Object error) {
                    EasyLoading.dismiss();
                    showMsg(context, 'Failed to add category');
                  });
            },
          );
        },
        child: const Icon(Icons.add),
      ),
      body: Consumer<CategoryProvider>(
        builder:
            (BuildContext context, CategoryProvider provider, Widget? child) {
              if (provider.categoryList.isEmpty) {
                return const Center(child: Text('No Category Found'));
              }

              return ListView.builder(
                itemCount: provider.categoryList.length,
                itemBuilder: (BuildContext context, int index) {
                  final category = provider.categoryList[index];
                  return ListTile(
                    title: Text(category.name),
                    trailing: Text(
                      '${category.productCount}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  );
                },
              );
            },
      ),
    );
  }
}
