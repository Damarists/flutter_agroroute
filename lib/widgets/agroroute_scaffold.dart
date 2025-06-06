import 'package:flutter/material.dart';

class AgroRouteScaffold extends StatelessWidget {
  final Widget body;
  final String title;
  final int selectedIndex;

  const AgroRouteScaffold({
    super.key,
    required this.body,
    this.title = 'AgroRoute',
    this.selectedIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 79, 92, 255),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(
                    'https://i.postimg.cc/BZ1WqRvG/image-removebg-preview.png',
                    height: 48,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'AgroRoute',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text('Dashboard'),
              selected: selectedIndex == 0,
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/dashboard',
                  (route) => false,
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.local_shipping),
              title: const Text('Envíos'),
              selected: selectedIndex == 1,
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/shipping',
                  (route) => false,
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.warning_amber),
              title: const Text('Gestión de Alertas'),
              selected: selectedIndex == 2,
              onTap: () {
                // Implementa la navegación si tienes la ruta
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.sensors),
              title: const Text('Sensores'),
              selected: selectedIndex == 3,
              onTap: () {
                // Implementa la navegación si tienes la ruta
                Navigator.pop(context);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Cerrar Sesión'),
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/',
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.black87),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
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
    );
  }
}
