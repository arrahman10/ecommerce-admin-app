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

  bool _obscurePassword = true;
  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    // Demo convenience: pre-fill admin credentials used in Firebase Auth.
    _emailController.text = 'admin@gmail.com';
    _passwordController.text = '123456@Ar';
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // ---------- Small admin logo / marker ----------
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(
                          Icons.admin_panel_settings_outlined,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // ---------- Heading & subtitle ----------
                    Text(
                      'Welcome back,',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Sign in to access the admin dashboard\nand manage your store.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.textTheme.bodyMedium?.color?.withOpacity(
                          0.8,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // ---------- Email field ----------
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Admin email',
                        prefixIcon: const Icon(Icons.email_outlined),
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Provide a valid email address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // ---------- Password field ----------
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                          ),
                        ),
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: theme.colorScheme.primary,
                          ),
                        ),
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

                    const SizedBox(height: 12),

                    // ---------- Remember me & Forgot password ----------
                    Row(
                      children: <Widget>[
                        Checkbox(
                          value: _rememberMe,
                          onChanged: (bool? value) {
                            setState(() {
                              _rememberMe = value ?? false;
                            });
                          },
                        ),
                        const Text('Remember me'),
                        const Spacer(),
                        TextButton(
                          onPressed: () {
                            showDialog<void>(
                              context: context,
                              builder: (BuildContext dialogContext) {
                                return AlertDialog(
                                  title: const Text('Forgot password?'),
                                  content: const Text(
                                    'For admin accounts, password resets are '
                                    'handled by the system owner or IT team.\n\n'
                                    'Please contact them to reset your admin password.',
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(dialogContext).pop(),
                                      child: const Text('OK'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: const Text('Forgot password?'),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // ---------- Sign in button ----------
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _authenticate,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              16,
                            ), // max radius
                          ),
                          backgroundColor: theme.colorScheme.primary,
                          foregroundColor: theme.colorScheme.onPrimary,
                          elevation: 0,
                        ),
                        child: const Text(
                          'Sign in as admin',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                    ),

                    if (_errMsg.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Text(
                          _errMsg,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.red,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
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
