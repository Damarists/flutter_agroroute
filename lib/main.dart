import 'package:flutter/material.dart';
import 'package:flutter_agroroute/PackageDetailScreen.dart';
import 'package:flutter_agroroute/ShipmentDetailScreen.dart';
import 'package:flutter_agroroute/shipments_screen.dart';
import 'package:flutter_agroroute/shipping_screen.dart';
import 'home_screen.dart';
import 'login_screen.dart';
import 'signup_screen.dart';

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
        '/shipments': (context) => ShipmentsScreen(),
        '/shipment-detail': (context) => const ShipmentDetailScreen(),
        '/shipping': (context) => const ShippingScreen(),
        '/package-detail': (context) => const PackageDetailScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
