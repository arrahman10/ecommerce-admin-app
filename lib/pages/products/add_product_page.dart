import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:ecommerce_admin_app/models/brand.dart';
import 'package:ecommerce_admin_app/models/category.dart';
import 'package:ecommerce_admin_app/providers/brand_provider.dart';
import 'package:ecommerce_admin_app/providers/category_provider.dart';

class AddProductPage extends StatefulWidget {
  static const String routeName = 'add_product';

  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _shortDescriptionController =
      TextEditingController();
  final TextEditingController _longDescriptionController =
      TextEditingController();
  final TextEditingController _purchasePriceController =
      TextEditingController();
  final TextEditingController _salePriceController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();

  Category? _selectedCategory;
  Brand? _selectedBrand;

  @override
  void dispose() {
    _nameController.dispose();
    _shortDescriptionController.dispose();
    _longDescriptionController.dispose();
    _purchasePriceController.dispose();
    _salePriceController.dispose();
    _stockController.dispose();
    _discountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Product')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                _buildImageSection(context),
                const SizedBox(height: 16),
                _buildCategoryBrandSection(context),
                const SizedBox(height: 16),
                _buildBasicInfoSection(context),
                const SizedBox(height: 16),
                _buildPricingSection(context),
                const SizedBox(height: 16),
                _buildInventorySection(context),
                const SizedBox(height: 24),
                _buildSubmitButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Image section
  Widget _buildImageSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Product image', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        InkWell(
          onTap: () {},
          child: Container(
            height: 150,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8.0),
            ),
            alignment: Alignment.center,
            child: Text(
              'Tap to select image\n(from camera or gallery)',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ),
      ],
    );
  }

  // Category + Brand section
  Widget _buildCategoryBrandSection(BuildContext context) {
    final CategoryProvider categoryProvider = context.watch<CategoryProvider>();
    final BrandProvider brandProvider = context.watch<BrandProvider>();

    final List<Category> categories = categoryProvider.categoryList;
    final List<Brand> brands = brandProvider.brandList;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Category & Brand',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Card(
          child: ListTile(
            title: const Text('Category'),
            subtitle: Text(
              _selectedCategory != null
                  ? '${_selectedCategory!.name} (${_selectedCategory!.productCount} products)'
                  : (categories.isEmpty
                        ? 'No category available'
                        : 'Tap to select category'),
            ),
            onTap: categories.isEmpty
                ? null
                : () => _showCategorySelectionDialog(context, categories),
          ),
        ),
        Card(
          child: ListTile(
            title: const Text('Brand'),
            subtitle: Text(
              _selectedBrand != null
                  ? (_selectedBrand!.productCount > 0
                        ? '${_selectedBrand!.name} (${_selectedBrand!.productCount} products)'
                        : _selectedBrand!.name)
                  : (brands.isEmpty
                        ? 'No brand available'
                        : 'Tap to select brand'),
            ),
            onTap: brands.isEmpty
                ? null
                : () => _showBrandSelectionDialog(context, brands),
          ),
        ),
      ],
    );
  }

  Future<void> _showCategorySelectionDialog(
    BuildContext context,
    List<Category> categories,
  ) async {
    final Category? selected = await showDialog<Category>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Select category'),
          children: <Widget>[
            for (final Category category in categories)
              SimpleDialogOption(
                onPressed: () => Navigator.pop<Category>(context, category),
                child: Text(
                  '${category.name} (${category.productCount} products)',
                ),
              ),
          ],
        );
      },
    );

    if (selected != null && mounted) {
      setState(() {
        _selectedCategory = selected;
      });
    }
  }

  Future<void> _showBrandSelectionDialog(
    BuildContext context,
    List<Brand> brands,
  ) async {
    final Brand? selected = await showDialog<Brand>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Select brand'),
          children: <Widget>[
            for (final Brand brand in brands)
              SimpleDialogOption(
                onPressed: () => Navigator.pop<Brand>(context, brand),
                child: Text(
                  brand.productCount > 0
                      ? '${brand.name} (${brand.productCount} products)'
                      : brand.name,
                ),
              ),
          ],
        );
      },
    );

    if (selected != null && mounted) {
      setState(() {
        _selectedBrand = selected;
      });
    }
  }

  // Basic info section
  Widget _buildBasicInfoSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Basic information',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _nameController,
          decoration: const InputDecoration(
            labelText: 'Product name',
            border: OutlineInputBorder(),
          ),
          textInputAction: TextInputAction.next,
          validator: (String? value) {
            if (value == null || value.trim().isEmpty) {
              return 'Provide a product name';
            }
            return null;
          },
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _shortDescriptionController,
          decoration: const InputDecoration(
            labelText: 'Short description',
            border: OutlineInputBorder(),
          ),
          textInputAction: TextInputAction.next,
          maxLines: 2,
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _longDescriptionController,
          decoration: const InputDecoration(
            labelText: 'Long description',
            border: OutlineInputBorder(),
          ),
          maxLines: 4,
        ),
      ],
    );
  }

  // Pricing section
  Widget _buildPricingSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Pricing', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Row(
          children: <Widget>[
            Expanded(
              child: TextFormField(
                controller: _purchasePriceController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Purchase price',
                  border: OutlineInputBorder(),
                ),
                textInputAction: TextInputAction.next,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                controller: _salePriceController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Sale price',
                  border: OutlineInputBorder(),
                ),
                textInputAction: TextInputAction.next,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Inventory section
  Widget _buildInventorySection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Inventory', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Row(
          children: <Widget>[
            Expanded(
              child: TextFormField(
                controller: _stockController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Quantity in stock',
                  border: OutlineInputBorder(),
                ),
                textInputAction: TextInputAction.next,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                controller: _discountController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Discount (%)',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Submit button
  Widget _buildSubmitButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _handleSubmit,
        child: const Text('Save product (skeleton)'),
      ),
    );
  }

  void _handleSubmit() {
    final bool isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }

    if (_selectedCategory == null || _selectedBrand == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select both category and brand.')),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Form is valid with category and brand. Product save logic will be implemented in the next commits.',
        ),
      ),
    );
  }
}
