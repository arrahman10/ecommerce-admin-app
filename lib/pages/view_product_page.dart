import 'package:flutter/material.dart';

class ViewProductPage extends StatefulWidget {
  static const String routeName = 'view-products';

  const ViewProductPage({super.key});

  @override
  State<ViewProductPage> createState() => _ViewProductPageState();
}

class _ViewProductPageState extends State<ViewProductPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('View Products')),
      body: const Center(
        child: Text(
          'View Products Page\n(placeholder - to be implemented)',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
