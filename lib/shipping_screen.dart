import 'package:flutter/material.dart';
import 'package:flutter_agroroute/widgets/agroroute_scaffold.dart';

class ShippingScreen extends StatelessWidget {
  const ShippingScreen({super.key});

  void _showNewShippingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          titlePadding: const EdgeInsets.only(top: 20, left: 20, right: 20),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
          actionsPadding: const EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'REGISTRO DE ENVÍO',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Origen',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Destino',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Fecha de envío',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  readOnly: true,
                  onTap: () {
                    // Aquí puedes agregar el selector de fecha
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Tipo de producto',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Envío registrado exitosamente'),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 79, 92, 255),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'GUARDAR',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AgroRouteScaffold(
      selectedIndex: 1, // Envíos
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Registro de envío',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () => _showNewShippingDialog(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 79, 92, 255),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Nuevo envío',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.1,
                children: List.generate(8, (index) {
                  return EnvioCard(
                    codigo: index == 6 ? "21A12L" : "11P12L",
                    origen: index == 6 ? "Arequipa" : "Piura",
                    destino: "Lima",
                    estado: index == 6
                        ? "Retrasado"
                        : index == 7
                        ? "Destino"
                        : "En tránsito",
                    fecha: "20/05/2025",
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EnvioCard extends StatelessWidget {
  final String codigo;
  final String origen;
  final String destino;
  final String estado;
  final String fecha;

  const EnvioCard({
    super.key,
    required this.codigo,
    required this.origen,
    required this.destino,
    required this.estado,
    required this.fecha,
  });

  Color _getEstadoColor(String estado) {
    switch (estado.toLowerCase()) {
      case "en tránsito":
        return Colors.blue;
      case "destino":
        return Colors.green;
      case "retrasado":
        return const Color.fromARGB(255, 228, 247, 61);
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shadowColor: Colors.grey.shade300,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Fila superior: Código y botón Monitorear
            Row(
              children: [
                Expanded(
                  child: Text(
                    "Código: $codigo",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13, // Reducir tamaño de fuente
                    ),
                    overflow: TextOverflow.ellipsis, // Para texto largo
                  ),
                ),
                const SizedBox(width: 4),
                SizedBox(
                  height: 32,
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: estado.toLowerCase() == "destino"
                            ? Colors.grey
                            : Colors.redAccent,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                    ),
                    child: Text(
                      "MONITOREAR",
                      style: TextStyle(
                        color: estado.toLowerCase() == "destino"
                            ? Colors.grey
                            : Colors.redAccent,
                        fontSize: 7, // Reducir tamaño de fuente
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Información del envío
            _buildInfoRow("Origen", origen),
            _buildInfoRow("Destino", destino),
            Row(
              children: [
                const Text(
                  "Estado: ",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                Text(
                  estado,
                  style: TextStyle(
                    color: _getEstadoColor(estado),
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            // Fila inferior: Fecha y acciones
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildInfoRow("Fecha", fecha),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, size: 18),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                          size: 18,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Text(
            "$label: ",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 14),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
