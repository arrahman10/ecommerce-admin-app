import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:ecommerce_admin_app/auth/auth_service.dart';
import 'package:ecommerce_admin_app/firebase_options.dart';
import 'package:ecommerce_admin_app/pages/products/add_product_page.dart';
import 'package:ecommerce_admin_app/pages/brands/brand_page.dart';
import 'package:ecommerce_admin_app/pages/categories/category_page.dart';
import 'package:ecommerce_admin_app/pages/dashboard_page.dart';
import 'package:ecommerce_admin_app/pages/login_page.dart';
import 'package:ecommerce_admin_app/pages/view_product_page.dart';
import 'package:ecommerce_admin_app/providers/brand_provider.dart';
import 'package:ecommerce_admin_app/providers/category_provider.dart';
import 'package:ecommerce_admin_app/providers/product_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<BrandProvider>(
          create: (BuildContext context) => BrandProvider(),
        ),
        ChangeNotifierProvider<CategoryProvider>(
          create: (BuildContext context) => CategoryProvider(),
        ),
        ChangeNotifierProvider<ProductProvider>(
          create: (BuildContext context) => ProductProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Ecommerce Admin App',
      debugShowCheckedModeBanner: false,
      builder: EasyLoading.init(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: _router,
    );
  }
}

final GoRouter _router = GoRouter(
  initialLocation: DashboardPage.routeName,
  redirect: (BuildContext context, GoRouterState state) {
    final bool isLoggedIn = AuthService.currentUser != null;
    final bool isLoggingIn = state.matchedLocation == LoginPage.routeName;

    if (!isLoggedIn && !isLoggingIn) {
      return LoginPage.routeName;
    }

    if (isLoggedIn && isLoggingIn) {
      return DashboardPage.routeName;
    }

    return null;
  },
  routes: <RouteBase>[
    GoRoute(
      name: DashboardPage.routeName,
      path: DashboardPage.routeName,
      builder: (BuildContext context, GoRouterState state) =>
          const DashboardPage(),
      routes: <RouteBase>[
        GoRoute(
          name: AddProductPage.routeName,
          path: AddProductPage.routeName,
          builder: (BuildContext context, GoRouterState state) =>
              const AddProductPage(),
        ),
        GoRoute(
          name: ViewProductPage.routeName,
          path: ViewProductPage.routeName,
          builder: (BuildContext context, GoRouterState state) =>
              const ViewProductPage(),
        ),
        GoRoute(
          name: CategoryPage.routeName,
          path: CategoryPage.routeName,
          builder: (BuildContext context, GoRouterState state) =>
              const CategoryPage(),
        ),
        GoRoute(
          name: BrandPage.routeName,
          path: BrandPage.routeName,
          builder: (BuildContext context, GoRouterState state) =>
              const BrandPage(),
        ),
      ],
    ),
    GoRoute(
      name: LoginPage.routeName,
      path: LoginPage.routeName,
      builder: (BuildContext context, GoRouterState state) => const LoginPage(),
    ),
  ],
);
