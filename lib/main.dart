import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:ecommerce_admin_app/auth/auth_service.dart';
import 'package:ecommerce_admin_app/firebase_options.dart';
import 'package:ecommerce_admin_app/models/product.dart';
import 'package:ecommerce_admin_app/pages/brands/brand_page.dart';
import 'package:ecommerce_admin_app/pages/categories/category_page.dart';
import 'package:ecommerce_admin_app/pages/dashboard_page.dart';
import 'package:ecommerce_admin_app/pages/login_page.dart';
import 'package:ecommerce_admin_app/pages/products/add_product_page.dart';
import 'package:ecommerce_admin_app/pages/products/product_details_page.dart';
import 'package:ecommerce_admin_app/pages/products/view_product_page.dart';
import 'package:ecommerce_admin_app/providers/brand_provider.dart';
import 'package:ecommerce_admin_app/providers/category_provider.dart';
import 'package:ecommerce_admin_app/providers/product_provider.dart';

// ================== Application entry point ==================

/// Entry point of the ecommerce admin application.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: <ChangeNotifierProvider<dynamic>>[
        ChangeNotifierProvider<CategoryProvider>(
          create: (BuildContext context) => CategoryProvider(),
        ),
        ChangeNotifierProvider<BrandProvider>(
          create: (BuildContext context) => BrandProvider(),
        ),
        ChangeNotifierProvider<ProductProvider>(
          create: (BuildContext context) => ProductProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

// ================== Root widget ==================

/// Root widget that configures the app theme and routing.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Ecommerce Admin App',
      debugShowCheckedModeBanner: false,
      // Wrap the app with EasyLoading to show global loading overlays.
      builder: EasyLoading.init(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        useMaterial3: true,
      ),
      routerConfig: _router,
    );
  }
}

// ================== Router configuration ==================

/// Global router configuration for the admin panel.
final GoRouter _router = GoRouter(
  // Start from the dashboard; redirect logic below will enforce auth.
  initialLocation: DashboardPage.routeName,
  redirect: (BuildContext context, GoRouterState state) {
    // Determine the current authentication state.
    final bool isLoggedIn = AuthService.currentUser != null;
    final bool isLoggingIn = state.matchedLocation == LoginPage.routeName;

    // If the user is not logged in, force navigation to the login page.
    if (!isLoggedIn && !isLoggingIn) {
      return LoginPage.routeName;
    }

    // If the user is already logged in, skip the login page.
    if (isLoggedIn && isLoggingIn) {
      return DashboardPage.routeName;
    }

    // Otherwise, do not redirect.
    return null;
  },
  routes: <RouteBase>[
    // Protected dashboard route with nested feature routes.
    GoRoute(
      name: DashboardPage.routeName,
      path: DashboardPage.routeName,
      builder: (BuildContext context, GoRouterState state) =>
          const DashboardPage(),
      routes: <RouteBase>[
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
          name: ProductDetailsPage.routeName,
          path: ProductDetailsPage.routeName,
          builder: (BuildContext context, GoRouterState state) {
            final Product product = state.extra! as Product;
            return ProductDetailsPage(product: product);
          },
        ),
      ],
    ),
    // Public login route used by the auth redirect.
    GoRoute(
      name: LoginPage.routeName,
      path: LoginPage.routeName,
      builder: (BuildContext context, GoRouterState state) => const LoginPage(),
    ),
  ],
);
