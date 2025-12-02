import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:ecommerce_admin_app/auth/auth_service.dart';
import 'package:ecommerce_admin_app/customwidgets/dashboard_item_view.dart';
import 'package:ecommerce_admin_app/models/dashboard_model.dart';
import 'package:ecommerce_admin_app/pages/login_page.dart';
import 'package:ecommerce_admin_app/providers/brand_provider.dart';

class DashboardPage extends StatefulWidget {
  static const String routeName = '/';

  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Provider.of<BrandProvider>(context, listen: false).getAllBrands();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: <Widget>[
          IconButton(
            onPressed: () async {
              await AuthService.logout();
              if (!mounted) return;
              context.goNamed(LoginPage.routeName);
            },
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
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
    );
  }
}
