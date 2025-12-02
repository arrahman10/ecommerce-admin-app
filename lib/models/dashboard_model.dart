import 'package:flutter/material.dart';

import 'package:ecommerce_admin_app/pages/add_product_page.dart';
import 'package:ecommerce_admin_app/pages/view_product_page.dart';
import 'package:ecommerce_admin_app/pages/brands/brand_page.dart';
import 'package:ecommerce_admin_app/pages/categories/category_page.dart';

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

const List<DashboardModel> dashboardModelList = <DashboardModel>[
  DashboardModel(
    title: 'Add Product',
    iconData: Icons.add_box_outlined,
    routeName: AddProductPage.routeName,
  ),
  DashboardModel(
    title: 'View Products',
    iconData: Icons.inventory_2_outlined,
    routeName: ViewProductPage.routeName,
  ),
  DashboardModel(
    title: 'Brands',
    iconData: Icons.category_outlined,
    routeName: BrandPage.routeName,
  ),
  DashboardModel(
    title: 'Categories',
    iconData: Icons.list_alt_outlined,
    routeName: CategoryPage.routeName,
  ),
];
