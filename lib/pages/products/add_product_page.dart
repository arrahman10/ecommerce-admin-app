import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'package:ecommerce_admin_app/models/brand.dart';
import 'package:ecommerce_admin_app/models/category.dart';
import 'package:ecommerce_admin_app/pages/dashboard_page.dart';
import 'package:ecommerce_admin_app/providers/brand_provider.dart';
import 'package:ecommerce_admin_app/providers/category_provider.dart';
import 'package:ecommerce_admin_app/providers/product_provider.dart';
import 'package:ecommerce_admin_app/utils/widget_functions.dart';

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

  final ImagePicker _picker = ImagePicker();
  XFile? _pickedImageFile;
  DateTime? _selectedPurchaseDate;
  bool _isSaving = false;

  String? _validateRequiredDouble(String? value, String fieldLabel) {
    final String trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return '$fieldLabel is required';
    }
    final double? parsed = double.tryParse(trimmed);
    if (parsed == null || parsed <= 0) {
      return 'Enter a valid positive $fieldLabel';
    }
    return null;
  }

  String? _validateRequiredInt(String? value, String fieldLabel) {
    final String trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return '$fieldLabel is required';
    }
    final int? parsed = int.tryParse(trimmed);
    if (parsed == null || parsed <= 0) {
      return 'Enter a valid positive $fieldLabel';
    }
    return null;
  }

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
          onTap: _pickImageFromGallery,
          child: Container(
            height: 150,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8.0),
            ),
            alignment: Alignment.center,
            child: _pickedImageFile == null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const Icon(Icons.image, size: 40, color: Colors.grey),
                      const SizedBox(height: 8),
                      Text(
                        'No image selected\nUse the buttons below to add image',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.file(
                      File(_pickedImageFile!.path),
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: <Widget>[
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _pickImageFromCamera,
                icon: const Icon(Icons.photo_camera),
                label: const Text('Capture'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _pickImageFromGallery,
                icon: const Icon(Icons.photo_library),
                label: const Text('Gallery'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            onPressed: _pickPurchaseDate,
            icon: const Icon(Icons.date_range),
            label: Text(
              _selectedPurchaseDate == null
                  ? 'Select purchase date'
                  : _formatDate(_selectedPurchaseDate!),
            ),
          ),
        ),
      ],
    );
  }

  void _pickImageFromCamera() {
    _pickImage(ImageSource.camera);
  }

  void _pickImageFromGallery() {
    _pickImage(ImageSource.gallery);
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? picked = await _picker.pickImage(
      source: source,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 80,
    );

    if (picked != null && mounted) {
      setState(() {
        _pickedImageFile = picked;
      });
    }
  }

  Future<void> _pickPurchaseDate() async {
    final DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedPurchaseDate ?? now,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 5),
    );

    if (picked != null && mounted) {
      setState(() {
        _selectedPurchaseDate = picked;
      });
    }
  }

  String _formatDate(DateTime date) {
    final String day = date.day.toString().padLeft(2, '0');
    final String month = date.month.toString().padLeft(2, '0');
    final String year = date.year.toString();
    return '$day/$month/$year';
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
                  ? _selectedCategory!.name
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
                  ? _selectedBrand!.name
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
      builder: (BuildContext dialogContext) {
        return SimpleDialog(
          title: const Text('Select category'),
          children: <Widget>[
            for (final Category category in categories)
              SimpleDialogOption(
                onPressed: () =>
                    Navigator.pop<Category>(dialogContext, category),
                child: Text(category.name),
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
      builder: (BuildContext dialogContext) {
        return SimpleDialog(
          title: const Text('Select brand'),
          children: <Widget>[
            for (final Brand brand in brands)
              SimpleDialogOption(
                onPressed: () => Navigator.pop<Brand>(dialogContext, brand),
                child: Text(brand.name),
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
                validator: (String? value) =>
                    _validateRequiredDouble(value, 'Purchase price'),
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
                validator: (String? value) =>
                    _validateRequiredDouble(value, 'Sale price'),
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
                textInputAction: TextInputAction.done,
                validator: (String? value) =>
                    _validateRequiredInt(value, 'Quantity in stock'),
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
        onPressed: _isSaving ? null : _handleSubmit,
        child: Text(_isSaving ? 'Saving...' : 'Save product'),
      ),
    );
  }

  Future<void> _handleSubmit() async {
    if (_pickedImageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a product image.')),
      );
      return;
    }

    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a category.')),
      );
      return;
    }

    if (_selectedBrand == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select a brand.')));
      return;
    }

    final bool isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }

    final ProductProvider productProvider = context.read<ProductProvider>();

    final double purchasePrice = double.parse(
      _purchasePriceController.text.trim(),
    );
    final double salePrice = double.parse(_salePriceController.text.trim());
    final int stock = int.parse(_stockController.text.trim());

    final double discount = _discountController.text.trim().isEmpty
        ? 0.0
        : double.parse(_discountController.text.trim());

    setState(() {
      _isSaving = true;
    });

    EasyLoading.show(status: 'Saving product...');

    try {
      await productProvider.addProductWithImage(
        imageFile: File(_pickedImageFile!.path),

        purchaseDate: _selectedPurchaseDate,

        category: _selectedCategory!,
        brand: _selectedBrand!,

        name: _nameController.text,
        shortDescription: _shortDescriptionController.text,
        longDescription: _longDescriptionController.text,

        purchasePrice: purchasePrice,
        salePrice: salePrice,
        stock: stock,
        discount: discount,
      );

      if (!mounted) return;

      showMsg(context, 'Product added successfully');

      _resetForm();

      context.goNamed(DashboardPage.routeName);
    } catch (e) {
      if (!mounted) return;

      showMsg(context, 'Failed to save product: $e');
    } finally {
      EasyLoading.dismiss();

      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  void _resetForm() {
    _formKey.currentState?.reset();

    _nameController.clear();
    _shortDescriptionController.clear();
    _longDescriptionController.clear();
    _purchasePriceController.clear();
    _salePriceController.clear();
    _stockController.clear();
    _discountController.clear();

    setState(() {
      _pickedImageFile = null;
      _selectedPurchaseDate = null;
      _selectedCategory = null;
      _selectedBrand = null;
    });
  }
}
