import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'login_screen.dart';
import 'signup_screen.dart';
import 'shipping_screen.dart';
import 'dashboard_screen.dart';

void main() {
  runApp(const AgroRouteApp());
}

class AgroRouteApp extends StatelessWidget {
  const AgroRouteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AgroRoute',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/shipping': (context) => const ShippingScreen(),
        '/dashboard': (context) => DashboardScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
