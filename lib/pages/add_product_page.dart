import 'package:flutter/material.dart';

class AddProductPage extends StatefulWidget {
  static const String routeName = 'add-product';

  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Product')),
      body: const Center(
        child: Text(
          'Add Product Page\n(placeholder - to be implemented)',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
