import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image (chai)
          Image.asset(
            "assets/chai.png",
            fit: BoxFit.cover,
          ),

          // Dark overlay to make form visible
          Container(
            color: Colors.black.withOpacity(0.4),
          ),

          // Login card in the center
          Center(
            child: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Log In",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.brown,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Username/Email
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: "Email",
                          prefixIcon: const Icon(Icons.email, color: Colors.brown),
                          filled: true,
                          fillColor: Colors.brown.shade50,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Password
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscure,
                        decoration: InputDecoration(
                          labelText: "Password",
                          prefixIcon: const Icon(Icons.lock, color: Colors.brown),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscure ? Icons.visibility : Icons.visibility_off,
                              color: Colors.brown,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscure = !_obscure;
                              });
                            },
                          ),
                          filled: true,
                          fillColor: Colors.brown.shade50,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Sign in button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.brown,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              Navigator.pushReplacementNamed(context, "/welcome");
                            }
                          },
                          child: const Text("Sign In"),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Register button
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, "/signup");
                        },
                        child: const Text(
                          "Register",
                          style: TextStyle(color: Colors.brown, fontSize: 16),
                        ),
                      ),

                      const SizedBox(height: 8),

                      GestureDetector(
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Forgot password not implemented")),
                          );
                        },
                        child: const Text(
                          "Forgot your password?",
                          style: TextStyle(color: Colors.brown),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
