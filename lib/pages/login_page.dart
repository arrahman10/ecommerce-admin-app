import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';

import 'package:ecommerce_admin_app/auth/auth_service.dart';
import 'package:ecommerce_admin_app/pages/dashboard_page.dart';

class LoginPage extends StatefulWidget {
  static const String routeName = '/login';

  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String _errMsg = '';

  @override
  void initState() {
    super.initState();
    // Demo convenience: pre-fill admin credentials used in Firebase Auth.
    _emailController.text = 'admin@gmail.com';
    _passwordController.text = '123456@Ar';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(24.0),
            shrinkWrap: true,
            children: <Widget>[
              Text(
                'Admin Login',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailController,
                  decoration: const InputDecoration(
                    filled: true,
                    prefixIcon: Icon(Icons.email),
                    labelText: 'Admin email address',
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Provide a valid email address';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: TextFormField(
                  obscureText: true,
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    filled: true,
                    prefixIcon: Icon(Icons.lock),
                    labelText: 'Password (at least 6 characters)',
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Provide a valid password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _authenticate,
                child: const Text('Login as Admin'),
              ),
              if (_errMsg.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    _errMsg,
                    style: const TextStyle(fontSize: 16, color: Colors.red),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _authenticate() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    EasyLoading.show(status: 'Please wait');

    final String email = _emailController.text.trim();
    final String password = _passwordController.text;

    try {
      final bool isAdmin = await AuthService.loginAdmin(email, password);
      EasyLoading.dismiss();

      if (isAdmin) {
        if (!mounted) return;
        context.goNamed(DashboardPage.routeName);
      } else {
        await AuthService.logout();
        if (!mounted) return;
        setState(() {
          _errMsg = 'This is not an Admin account';
        });
      }
    } on FirebaseAuthException catch (error) {
      EasyLoading.dismiss();
      setState(() {
        _errMsg = error.message ?? 'Authentication failed';
      });
    } catch (_) {
      EasyLoading.dismiss();
      setState(() {
        _errMsg = 'An unexpected error occurred. Please try again.';
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
