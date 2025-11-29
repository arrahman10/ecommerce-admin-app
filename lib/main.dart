import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';

import 'package:ecommerce_admin_app/auth/auth_service.dart';
import 'package:ecommerce_admin_app/firebase_options.dart';
import 'package:ecommerce_admin_app/pages/dashboard_page.dart';
import 'package:ecommerce_admin_app/pages/login_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
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
    ),
    GoRoute(
      name: LoginPage.routeName,
      path: LoginPage.routeName,
      builder: (BuildContext context, GoRouterState state) => const LoginPage(),
    ),
  ],
);
