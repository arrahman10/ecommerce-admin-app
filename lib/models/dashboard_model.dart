import 'package:flutter/material.dart';

import 'package:ecommerce_admin_app/pages/brands/brand_page.dart';
import 'package:ecommerce_admin_app/pages/categories/category_page.dart';
import 'package:ecommerce_admin_app/pages/products/add_product_page.dart';
import 'package:ecommerce_admin_app/pages/products/view_product_page.dart';

/// Simple configuration model for a single dashboard tile.
///
/// Each tile has a [title], an [iconData] used in the UI, and a [routeName]
/// which is used by the router to navigate when the tile is tapped.
class DashboardModel {
  /// Text label shown under the dashboard icon.
  final String title;

  /// Icon representing the dashboard section.
  final IconData iconData;

  /// Named route used for navigation when this tile is tapped.
  ///
  /// When [routeName] is [dashboardRoutePlaceholder] the tile does not
  /// navigate, instead a placeholder SnackBar is shown.
  final String routeName;

  const DashboardModel({
    required this.title,
    required this.iconData,
    required this.routeName,
  });
}

/// Placeholder route value used for dashboard tiles that are not implemented yet.
///
/// When a tile uses this value, tapping it will only show a SnackBar instead
/// of navigating to a new page.
const String dashboardRoutePlaceholder = '';

/// Static configuration for all dashboard tiles in the admin home screen.
///
/// The order of items in this list controls the visual order in the grid.
const List<DashboardModel> dashboardModelList = <DashboardModel>[
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
