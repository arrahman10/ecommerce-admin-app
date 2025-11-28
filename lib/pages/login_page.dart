import 'package:flutter/material.dart';

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
                'Ecommerce Admin Login',
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

  void _authenticate() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _errMsg = 'Authentication will be implemented in the next step.';
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
