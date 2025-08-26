
import 'package:flutter/material.dart';
import 'pages/auth_page.dart';
import 'pages/welcome_page.dart';
import 'pages/menu_page.dart';
import 'pages/order_list_page.dart';
import 'pages/payment_page.dart';

const String routeAuth = '/auth';
const String routeWelcome = '/welcome';
const String routeMenu = '/menu';
const String routeOrders = '/orders';
const String routePayment = '/payment';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ChaiShopApp());
}

class ChaiShopApp extends StatelessWidget {
  const ChaiShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chai Shop',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.brown),
      initialRoute: routeAuth,
      routes: {
        routeAuth: (context) => const AuthPage(),
        routeWelcome: (context) => const WelcomePage(),
        routeMenu: (context) => const MenuPage(),
        routeOrders: (context) => const OrderListPage(), // <-- ensure exact class name
        routePayment: (context) => const PaymentPage(),
      },
    );
  }
}
