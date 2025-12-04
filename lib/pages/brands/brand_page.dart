import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

import 'package:ecommerce_admin_app/providers/brand_provider.dart';
import 'package:ecommerce_admin_app/utils/widget_functions.dart';

class BrandPage extends StatelessWidget {
  static const String routeName = 'brands';

  const BrandPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('All Brands')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showSingleTextInputDialog(
            context: context,
            title: 'Add Brand',
            onSubmit: (String value) {
              if (value.trim().isEmpty) return;

              EasyLoading.show(status: 'Please wait');
              Provider.of<BrandProvider>(context, listen: false)
                  .addBrand(value)
                  .then((_) {
                    EasyLoading.dismiss();
                    showMsg(context, 'Brand added');
                  })
                  .catchError((Object error) {
                    EasyLoading.dismiss();
                    showMsg(context, 'Failed to add brand');
                  });
            },
          );
        },
        child: const Icon(Icons.add),
      ),
      body: Consumer<BrandProvider>(
        builder: (BuildContext context, BrandProvider provider, Widget? child) {
          if (provider.brandList.isEmpty) {
            return const Center(child: Text('No Brand Found'));
          }

          return ListView.builder(
            itemCount: provider.brandList.length,
            itemBuilder: (BuildContext context, int index) {
              final brand = provider.brandList[index];
              return ListTile(
                title: Text(brand.name),
                trailing: Text(
                  '${brand.productCount}',
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
