import 'package:flutter/material.dart';
import 'package:flutter_agroroute/widgets/agroroute_scaffold.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PackageDetailScreen extends StatelessWidget {
  const PackageDetailScreen({super.key});

  Future<Map<String, dynamic>?> fetchOwner(int ownerId) async {
    final response = await http.get(
      Uri.parse('http://localhost:3000/api/v1/users/$ownerId'),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments;
    if (args == null || args is! Map<String, dynamic>) {
      return const Scaffold(
        body: Center(child: Text('No hay datos para mostrar')),
      );
    }
    final Map<String, dynamic> pkg = args;
    final fecha = DateTime.tryParse(pkg['fecha'] ?? '') ?? DateTime.now();
    final ownerId = pkg['shipmentOwnerId'];

    return AgroRouteScaffold(
      selectedIndex: 2,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.amber.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: const Icon(
                    Icons.inventory_2,
                    color: Colors.amber,
                    size: 36,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Paquete ${pkg['codigo'] ?? pkg['id'] ?? ''}',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                leading: const Icon(Icons.calendar_today, color: Colors.blue),
                title: const Text("Fecha de envío"),
                subtitle: Text(fecha.toLocal().toString().split(' ')[0]),
              ),
            ),
            const SizedBox(height: 8),
            FutureBuilder<Map<String, dynamic>?>(
              future: fetchOwner(ownerId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Card(
                    child: ListTile(
                      leading: Icon(Icons.person, color: Colors.indigo),
                      title: Text("Dueño del envío"),
                      subtitle: Text("Cargando..."),
                    ),
                  );
                }
                if (!snapshot.hasData || snapshot.data == null) {
                  return const Card(
                    child: ListTile(
                      leading: Icon(Icons.person, color: Colors.indigo),
                      title: Text("Dueño del envío"),
                      subtitle: Text("No encontrado"),
                    ),
                  );
                }
                final user = snapshot.data!;
                return Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.person, color: Colors.indigo),
                    title: const Text("Dueño del envío"),
                    subtitle: Text("${user['firstName']} ${user['lastName']}"),
                  ),
                );
              },
            ),
            const SizedBox(height: 18),
            const Text(
              'Detalles',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 8),
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(
                      Icons.person_outline,
                      color: Colors.teal,
                    ),
                    title: const Text("Cliente"),
                    subtitle: Text(pkg['cliente'] ?? ''),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(
                      Icons.location_on,
                      color: Colors.redAccent,
                    ),
                    title: const Text("Destino"),
                    subtitle: Text(pkg['destino'] ?? ''),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(
                      Icons.description,
                      color: Colors.orange,
                    ),
                    title: const Text("Descripción"),
                    subtitle: Text(
                      pkg['descripcion'] ?? pkg['description'] ?? '',
                    ),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(
                      Icons.monitor_weight,
                      color: Colors.brown,
                    ),
                    title: const Text("Peso"),
                    subtitle: Text("${pkg['peso'] ?? pkg['weight'] ?? ''} kg"),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.height, color: Colors.blueGrey),
                    title: const Text("Alto"),
                    subtitle: Text("${pkg['alto'] ?? pkg['height'] ?? ''} cm"),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(
                      Icons.straighten,
                      color: Colors.blueGrey,
                    ),
                    title: const Text("Ancho"),
                    subtitle: Text("${pkg['ancho'] ?? pkg['width'] ?? ''} cm"),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(
                      Icons.straighten,
                      color: Colors.blueGrey,
                    ),
                    title: const Text("Largo"),
                    subtitle: Text("${pkg['largo'] ?? pkg['length'] ?? ''} cm"),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'Sensores',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 8),
            if ((pkg['sensores'] as List?)?.isNotEmpty ?? false)
              Card(
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: (pkg['sensores'] as List)
                      .map<Widget>(
                        (sensor) => ListTile(
                          leading: const Icon(
                            Icons.sensors,
                            color: Colors.deepPurple,
                          ),
                          title: Text(sensor['tipo'] ?? ''),
                          subtitle: Text(sensor['valor'] ?? ''),
                        ),
                      )
                      .toList(),
                ),
              )
            else
              const Text("No hay sensores registrados."),
          ],
        ),
      ),
    );
  }
}
