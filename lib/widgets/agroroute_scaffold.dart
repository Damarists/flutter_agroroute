import 'package:flutter/material.dart';

class AgroRouteScaffold extends StatelessWidget {
  final Widget body;
  final String title;
  final int selectedIndex;
  final FloatingActionButton? floatingActionButton;

  const AgroRouteScaffold({
    super.key,
    required this.body,
    this.title = 'AgroRoute',
    this.selectedIndex = 0,
    this.floatingActionButton,
  });

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/dashboard',
          (route) => false,
        );
        break;
      case 1:
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/shipments',
          (route) => false,
        );
        break;
      case 2:
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/shipping',
          (route) => false,
        );
        break;
      case 3:
        // Implementa la navegación si tienes la ruta de alertas
        break;
      case 4:
        // Implementa la navegación si tienes la ruta de sensores
        break;
      case 5:
        // Logout
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Image.network(
              'https://i.postimg.cc/C14Xnp9v/image.png',
              height: 40,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: CircleAvatar(
              backgroundImage: NetworkImage(
                'https://cdn-icons-png.flaticon.com/512/74/74472.png',
              ),
            ),
          ),
        ],
      ),
      body: body,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index) => _onItemTapped(context, index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color.fromARGB(255, 79, 92, 255),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_shipping),
            label: 'Envíos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2),
            label: 'Paquetes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.warning_amber),
            label: 'Alertas',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.sensors), label: 'Sensores'),
          BottomNavigationBarItem(icon: Icon(Icons.logout), label: 'Salir'),
        ],
      ),
    );
  }
}
