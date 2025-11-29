import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:ecommerce_admin_app/auth/auth_service.dart';
import 'package:ecommerce_admin_app/pages/login_page.dart';

class DashboardPage extends StatefulWidget {
  static const String routeName = '/';

  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
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
      body: const Center(
        child: Text(
          'Dashboard Page\n(Ecommerce Admin)',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
