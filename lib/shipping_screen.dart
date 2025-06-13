import 'package:flutter/material.dart';
import 'package:flutter_agroroute/widgets/agroroute_scaffold.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ShippingScreen extends StatefulWidget {
  const ShippingScreen({super.key});

  @override
  State<ShippingScreen> createState() => _ShippingScreenState();
}

class _ShippingScreenState extends State<ShippingScreen> {
  final List<Map<String, dynamic>> _packages = [];

  @override
  void initState() {
    super.initState();
    _fetchPackages();
  }

  Future<void> _fetchPackages() async {
    final response = await http.get(
      Uri.parse('http://localhost:3000/api/v1/shipments'),
    );
    if (response.statusCode == 200) {
      final List shipments = jsonDecode(response.body);
      final List<Map<String, dynamic>> packages = [];
      for (final shipment in shipments) {
        final List paquetes = shipment['paquetes'] ?? [];
        for (final paquete in paquetes) {
          // Puedes agregar referencia al envío si lo necesitas:
          packages.add({
            ...paquete,
            'shipmentTracking': shipment['trackingNumber'],
            'shipmentDestino': shipment['destino'],
            'shipmentOwnerId': shipment['ownerId'],
          });
        }
      }
      setState(() {
        _packages
          ..clear()
          ..addAll(packages);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AgroRouteScaffold(
      selectedIndex: 2,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Paquetes',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _packages.isEmpty
                  ? const Center(child: Text('No hay paquetes registrados'))
                  : ListView.separated(
                      itemCount: _packages.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final pkg = _packages[index];
                        final fecha =
                            DateTime.tryParse(pkg['fecha'] ?? '') ??
                            DateTime.now();
                        return Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(right: 16.0),
                                  child: Icon(
                                    Icons.inventory_2,
                                    size: 40,
                                    color: Color.fromARGB(255, 212, 181, 5),
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Código: ${pkg['codigo'] ?? ''}",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text("Cliente: ${pkg['cliente'] ?? ''}"),
                                      Text("Destino: ${pkg['destino'] ?? ''}"),
                                      Text(
                                        "Fecha: ${fecha.toLocal().toString().split(' ')[0]}",
                                      ),
                                      Text("Estado: ${pkg['estado'] ?? ''}"),
                                      Text(
                                        "Tracking envío: ${pkg['shipmentTracking'] ?? ''}",
                                      ),
                                    ],
                                  ),
                                ),
                                OutlinedButton(
                                  onPressed: () {
                                    Navigator.pushNamed(
                                      context,
                                      '/package-detail',
                                      arguments: pkg,
                                    );
                                  },
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(color: Colors.red),
                                    foregroundColor: Colors.red,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 4,
                                    ),
                                  ),
                                  child: const Text(
                                    'Monitorear',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
