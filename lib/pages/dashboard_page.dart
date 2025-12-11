import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:ecommerce_admin_app/auth/auth_service.dart';
import 'package:ecommerce_admin_app/customwidgets/dashboard_item_view.dart';
import 'package:ecommerce_admin_app/models/dashboard_model.dart';
import 'package:ecommerce_admin_app/pages/login_page.dart';
import 'package:ecommerce_admin_app/providers/brand_provider.dart';
import 'package:ecommerce_admin_app/providers/category_provider.dart';

/// Main admin dashboard page.
///
/// Shows a grid of high-level actions (categories, brands, products, etc.)
/// and ensures that initial brand/category data is loaded via providers.
class DashboardPage extends StatefulWidget {
  /// Route name used with [GoRouter] navigation.
  static const String routeName = '/';

  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  // ================== Lifecycle ==================

  /// Load initial data (brands and categories) when dependencies change.
  ///
  /// This ensures that providers have their data ready when the dashboard
  /// grid and its child pages are used.
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Provider.of<BrandProvider>(context, listen: false).getAllBrands();
    Provider.of<CategoryProvider>(context, listen: false).getAllCategories();
  }

  // ================== UI build ==================

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: <Widget>[
          IconButton(
            onPressed: () async {
              await AuthService.logout();
              if (!mounted) {
                return;
              }
              context.goNamed(LoginPage.routeName);
            },
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Container(
        color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
        child: GridView.builder(
          padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.0,
            mainAxisSpacing: 2,
            crossAxisSpacing: 2,
          ),
          itemCount: dashboardModelList.length,
          itemBuilder: (BuildContext context, int index) {
            final DashboardModel model = dashboardModelList[index];
            return DashboardItemView(
              model: model,
              onTap: (String routeName) {
                context.goNamed(routeName);
              },
            );
          },
        ),
      ),
    );
  }
}
