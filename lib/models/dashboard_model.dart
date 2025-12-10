import 'package:flutter/material.dart';

import 'package:ecommerce_admin_app/pages/products/add_product_page.dart';
import 'package:ecommerce_admin_app/pages/products/view_product_page.dart';
import 'package:ecommerce_admin_app/pages/categories/category_page.dart';
import 'package:ecommerce_admin_app/pages/brands/brand_page.dart';

class DashboardModel {
  final String title;
  final IconData iconData;
  final String routeName;

  const DashboardModel({
    required this.title,
    required this.iconData,
    required this.routeName,
  });
}

// Empty route means: just show placeholder SnackBar, no navigation yet.
const String dashboardRoutePlaceholder = '';

final List<DashboardModel> dashboardModelList = <DashboardModel>[
  DashboardModel(
    title: 'Add Product',
    iconData: Icons.add_box_rounded,
    routeName: AddProductPage.routeName,
  ),
  DashboardModel(
    title: 'View Products',
    iconData: Icons.inventory_2_rounded,
    routeName: ViewProductPage.routeName,
  ),

  DashboardModel(
    title: 'Categories',
    iconData: Icons.category_rounded,
    routeName: CategoryPage.routeName,
  ),

  DashboardModel(
    title: 'Brands',
    iconData: Icons.grade,
    routeName: BrandPage.routeName,
  ),

  DashboardModel(
    title: 'Orders',
    // iconData: Icons.receipt_long_rounded,
    iconData: Icons.receipt_rounded,
    routeName: dashboardRoutePlaceholder,
  ),

  DashboardModel(
    title: 'Users',
    iconData: Icons.person_rounded,
    routeName: dashboardRoutePlaceholder,
  ),
  DashboardModel(
    title: 'Settings',
    iconData: Icons.settings_rounded,
    routeName: dashboardRoutePlaceholder,
  ),
  DashboardModel(
    title: 'Report',
    iconData: Icons.pie_chart_rounded,
    routeName: dashboardRoutePlaceholder,
  ),
];
