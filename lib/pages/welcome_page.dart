import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  void _navigate(BuildContext context, String route) {
    Navigator.pushNamed(context, route);
  }

  Future<void> _signOut(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Sign out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Cancel')),
          TextButton(
              onPressed: () => Navigator.pop(c, true),
              child: const Text('Sign out', style: TextStyle(color: Colors.red))),
        ],
      ),
    );
    if (confirmed == true) {
      Navigator.pushNamedAndRemoveUntil(context, '/auth', (_) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Welcome'),
          centerTitle: true,
          actions: [
            IconButton(
              tooltip: 'Orders',
              icon: const Icon(Icons.list_alt),
              onPressed: () => _navigate(context, '/orders'),
            ),
            IconButton(
              tooltip: 'Payment',
              icon: const Icon(Icons.payment),
              onPressed: () => _navigate(context, '/payment'),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 8),
              const Row(
                children: [
                  CircleAvatar(
                    radius: 36,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.local_cafe, size: 36, color: Colors.black),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Welcome to Chai Shop\nFresh chai, warm smiles.',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Quick actions',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  children: [
                    _ActionCard(
                      icon: Icons.restaurant_menu,
                      label: 'Menu',
                      color: const Color.fromARGB(97, 30, 81, 106),
                      onTap: () => _navigate(context, '/menu'),
                    ),
                    _ActionCard(
                      icon: Icons.shopping_cart,
                      label: 'Orders',
                      color: const Color.fromARGB(97, 30, 81, 106),
                      onTap: () => _navigate(context, '/orders'),
                    ),
                    _ActionCard(
                      icon: Icons.payment,
                      label: 'Payment',
                      color: const Color.fromARGB(97, 30, 81, 106),
                      onTap: () => _navigate(context, '/payment'),
                    ),
                    _ActionCard(
                      icon: Icons.logout,
                      label: 'Sign out',
                      color: Colors.redAccent,
                      onTap: () => _signOut(context),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: () => _navigate(context, '/menu'),
                icon: const Icon(Icons.coffee, color: Colors.white),
                label: const Text('Order now'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.grey[900],
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundColor: color,
                child: Icon(icon, color: const Color.fromARGB(255, 52, 92, 78)),
              ),
              const SizedBox(height: 12),
              Text(
                label,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
                    