import 'package:flutter/material.dart';
import 'package:flutter_agroroute/widgets/agroroute_scaffold.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ShipmentDetailScreen extends StatelessWidget {
  const ShipmentDetailScreen({super.key});

  // Función para obtener el usuario por id desde el backend
  Future<Map<String, dynamic>?> fetchUser(int userId) async {
    final response = await http.get(
      Uri.parse('http://localhost:3000/api/v1/users/$userId'),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    }
    return null;
  }

  // Convierte la lista de sensores a texto
  String sensoresToString(List<dynamic>? sensores) {
    if (sensores == null || sensores.isEmpty) return '';
    return sensores.map((s) => "${s['tipo']}: ${s['valor']}").join(', ');
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments;
    if (args == null || args is! Map<String, dynamic>) {
      return const Scaffold(
        body: Center(child: Text('No hay datos para mostrar')),
      );
    }
    final Map<String, dynamic> shipment = args;
    final fecha = DateTime.tryParse(shipment['fecha'] ?? '') ?? DateTime.now();

    return AgroRouteScaffold(
      selectedIndex: 1,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.blueAccent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: const Icon(
                    Icons.local_shipping,
                    color: Colors.blueAccent,
                    size: 36,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Detalle del Envío',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Propietario (con FutureBuilder)
            FutureBuilder<Map<String, dynamic>?>(
              future: fetchUser(shipment['ownerId']),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const ListTile(
                    leading: Icon(Icons.person, color: Colors.indigo),
                    title: Text("Propietario"),
                    subtitle: Text("Cargando..."),
                  );
                }
                if (!snapshot.hasData || snapshot.data == null) {
                  return const ListTile(
                    leading: Icon(Icons.person, color: Colors.indigo),
                    title: Text("Propietario"),
                    subtitle: Text("No encontrado"),
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
                    title: const Text(
                      "Propietario",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text("${user['firstName']} ${user['lastName']}"),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),

            // Tracking Number
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                leading: const Icon(
                  Icons.confirmation_number,
                  color: Colors.indigo,
                ),
                title: const Text(
                  "ID de Tracking",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  shipment['trackingNumber'] ?? '',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Destino
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                leading: const Icon(Icons.location_on, color: Colors.teal),
                title: const Text(
                  "Destino",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(shipment['destino'] ?? ''),
              ),
            ),
            const SizedBox(height: 12),

            // Fecha
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                leading: const Icon(Icons.calendar_today, color: Colors.teal),
                title: const Text(
                  "Fecha",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(fecha.toLocal().toString().split(' ')[0]),
              ),
            ),
            const SizedBox(height: 12),

            // Estado
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                leading: const Icon(Icons.info, color: Colors.orange),
                title: const Text(
                  "Estado",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(shipment['estado'] ?? ''),
              ),
            ),
            const SizedBox(height: 12),

            // Ubicación activada
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                leading: const Icon(Icons.gps_fixed, color: Colors.green),
                title: const Text(
                  "Ubicación activada",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text((shipment['ubicacion'] ?? false) ? 'Sí' : 'No'),
              ),
            ),
            const SizedBox(height: 24),

            // Paquetes en tabla
            const Text(
              "Paquetes",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 10),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Código')),
                  DataColumn(label: Text('Cliente')),
                  DataColumn(label: Text('Destino')),
                  DataColumn(label: Text('Sensores')),
                  DataColumn(label: Text('Fecha')),
                  DataColumn(label: Text('Estado')),
                ],
                rows: (shipment['paquetes'] as List<dynamic>? ?? []).map((p) {
                  final fechaPaquete =
                      DateTime.tryParse(p['fecha'] ?? '') ?? DateTime.now();
                  return DataRow(
                    cells: [
                      DataCell(Text(p['codigo'] ?? '')),
                      DataCell(Text(p['cliente'] ?? '')),
                      DataCell(Text(p['destino'] ?? '')),
                      DataCell(
                        Text(sensoresToString(p['sensores'] as List<dynamic>?)),
                      ),
                      DataCell(
                        Text(fechaPaquete.toLocal().toString().split(' ')[0]),
                      ),
                      DataCell(Text(p['estado'] ?? '')),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
