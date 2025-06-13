import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_agroroute/user_session.dart';
import 'package:flutter_agroroute/widgets/agroroute_scaffold.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ShipmentsScreen extends StatefulWidget {
  const ShipmentsScreen({super.key});

  @override
  State<ShipmentsScreen> createState() => _ShipmentsScreenState();
}

class _ShipmentsScreenState extends State<ShipmentsScreen> {
  final List<Map<String, dynamic>> _shipments = [];

  @override
  void initState() {
    super.initState();
    _fetchShipments();
  }

  Future<void> _fetchShipments() async {
    final response = await http.get(
      Uri.parse('http://localhost:3000/api/v1/shipments'),
    );
    if (response.statusCode == 200) {
      setState(() {
        _shipments.clear();
        _shipments.addAll(
          List<Map<String, dynamic>>.from(jsonDecode(response.body)),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AgroRouteScaffold(
      selectedIndex: 1,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Envíos',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _shipments.isEmpty
                  ? const Center(child: Text('No hay envíos registrados'))
                  : ListView.builder(
                      itemCount: _shipments.length,
                      itemBuilder: (context, index) {
                        final shipment = _shipments[index];
                        final fecha =
                            DateTime.tryParse(shipment['fecha'] ?? '') ??
                            DateTime.now();
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            leading: const Icon(
                              Icons.local_shipping,
                              size: 40,
                              color: Colors.blueAccent,
                            ),
                            title: Text(
                              'Tracking: ${shipment['trackingNumber']}',
                            ),
                            subtitle: Text(
                              'Destino: ${shipment['destino']}\n'
                              'Fecha: ${fecha.toLocal().toString().split(' ')[0]}\n'
                              'Estado: ${shipment['estado']}',
                            ),
                            trailing: OutlinedButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  '/shipment-detail',
                                  arguments: shipment,
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
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text('Nuevo Envío'),
        onPressed: () async {
          final result = await showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (_) => NewShipmentForm(userId: UserSession.userId!),
          );
          if (result != null) {
            setState(() {
              _shipments.add(result as Map<String, dynamic>);
            });
          }
        },
      ),
    );
  }
}

class NewShipmentForm extends StatefulWidget {
  final int userId;
  const NewShipmentForm({super.key, required this.userId});

  @override
  State<NewShipmentForm> createState() => _NewShipmentFormState();
}

class _NewShipmentFormState extends State<NewShipmentForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _destinoController = TextEditingController();
  DateTime? _fecha;
  bool _ubicacion = false;
  List<Map<String, dynamic>> paquetes = [];

  String _generarTrackingId() {
    final rand = Random();
    return 'TRK${rand.nextInt(9000) + 1000}';
  }

  late String trackingId;

  @override
  void initState() {
    super.initState();
    trackingId = _generarTrackingId();
  }

  void _agregarPaquete() async {
    if (_fecha == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Primero seleccione la fecha del envío')),
      );
      return;
    }
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (_) => NewPackageDialog(maxDate: _fecha!),
    );
    if (result != null) {
      setState(() {
        paquetes.add(result);
      });
    }
  }

  Future<void> _guardarEnvio() async {
    if (_formKey.currentState!.validate() &&
        _fecha != null &&
        paquetes.isNotEmpty) {
      final envio = {
        "trackingNumber": trackingId,
        "ownerId": widget.userId,
        "destino": _destinoController.text,
        "fecha": _fecha!.toIso8601String(),
        "estado": "En proceso",
        "ubicacion": _ubicacion,
        "paquetes": paquetes,
      };
      final response = await http.post(
        Uri.parse('http://localhost:3000/api/v1/shipments'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(envio),
      );
      if (response.statusCode == 201) {
        Navigator.pop(context, envio); // Devuelve el envío creado
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Nuevo Envío ($trackingId)',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              TextFormField(
                controller: _destinoController,
                decoration: const InputDecoration(labelText: 'Destino'),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Ingrese destino' : null,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Text('Fecha: '),
                  Text(
                    _fecha == null
                        ? 'No seleccionada'
                        : _fecha!.toLocal().toString().split(' ')[0],
                  ),
                  IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) setState(() => _fecha = picked);
                    },
                  ),
                ],
              ),
              CheckboxListTile(
                value: _ubicacion,
                onChanged: (v) => setState(() => _ubicacion = v ?? false),
                title: const Text('Activar ubicación'),
              ),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                icon: const Icon(Icons.add_box),
                label: const Text('Registrar paquete'),
                onPressed: _agregarPaquete,
              ),
              const SizedBox(height: 8),
              ...paquetes.map(
                (p) => ListTile(
                  title: Text('Paquete ${p['codigo']} - ${p['cliente']}'),
                  subtitle: Text('Destino: ${p['destino']}'),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _guardarEnvio,
                child: const Text('Guardar Envío'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NewPackageDialog extends StatefulWidget {
  final DateTime maxDate;
  const NewPackageDialog({super.key, required this.maxDate});

  @override
  State<NewPackageDialog> createState() => _NewPackageDialogState();
}

class _NewPackageDialogState extends State<NewPackageDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _clienteController = TextEditingController();
  final TextEditingController _destinoController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  final TextEditingController _pesoController = TextEditingController();
  final TextEditingController _altoController = TextEditingController();
  final TextEditingController _anchoController = TextEditingController();
  final TextEditingController _largoController = TextEditingController();
  DateTime? _fecha;
  bool _ubicacion = false;
  List<Map<String, String>> sensores = [];

  String _generarCodigoPaquete() {
    final rand = Random();
    return 'PQ${rand.nextInt(9000) + 1000}';
  }

  late String codigoPaquete;

  @override
  void initState() {
    super.initState();
    codigoPaquete = _generarCodigoPaquete();
  }

  void _agregarSensor() async {
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (_) => const NewSensorDialog(),
    );
    if (result != null) {
      setState(() {
        sensores.add(result);
      });
    }
  }

  void _guardarPaquete() {
    if (_formKey.currentState!.validate() &&
        _fecha != null &&
        sensores.isNotEmpty) {
      if (_fecha!.isAfter(widget.maxDate)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'La fecha del paquete no puede ser mayor a la del envío',
            ),
          ),
        );
        return;
      }
      Navigator.pop(context, {
        "codigo": codigoPaquete,
        "cliente": _clienteController.text,
        "destino": _destinoController.text,
        "sensores": sensores,
        "ubicacion": _ubicacion,
        "descripcion": _descripcionController.text,
        "peso": _pesoController.text,
        "alto": _altoController.text,
        "ancho": _anchoController.text,
        "largo": _largoController.text,
        "fecha": _fecha!.toIso8601String(),
        "estado": "En proceso",
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Nuevo Paquete ($codigoPaquete)'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _clienteController,
                decoration: const InputDecoration(
                  labelText: 'Nombre del cliente',
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Ingrese cliente' : null,
              ),
              TextFormField(
                controller: _destinoController,
                decoration: const InputDecoration(labelText: 'Destino'),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Ingrese destino' : null,
              ),
              TextFormField(
                controller: _descripcionController,
                decoration: const InputDecoration(
                  labelText: 'Descripción del paquete',
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Ingrese descripción' : null,
              ),
              TextFormField(
                controller: _pesoController,
                decoration: const InputDecoration(labelText: 'Peso'),
                keyboardType: TextInputType.number,
                validator: (v) =>
                    v == null || v.isEmpty ? 'Ingrese peso' : null,
              ),
              TextFormField(
                controller: _altoController,
                decoration: const InputDecoration(labelText: 'Alto'),
                keyboardType: TextInputType.number,
                validator: (v) =>
                    v == null || v.isEmpty ? 'Ingrese alto' : null,
              ),
              TextFormField(
                controller: _anchoController,
                decoration: const InputDecoration(labelText: 'Ancho'),
                keyboardType: TextInputType.number,
                validator: (v) =>
                    v == null || v.isEmpty ? 'Ingrese ancho' : null,
              ),
              TextFormField(
                controller: _largoController,
                decoration: const InputDecoration(labelText: 'Largo'),
                keyboardType: TextInputType.number,
                validator: (v) =>
                    v == null || v.isEmpty ? 'Ingrese largo' : null,
              ),
              Row(
                children: [
                  const Text('Fecha: '),
                  Text(
                    _fecha == null
                        ? 'No seleccionada'
                        : _fecha!.toLocal().toString().split(' ')[0],
                  ),
                  IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: widget.maxDate, // <-- Limita la fecha máxima
                      );
                      if (picked != null) setState(() => _fecha = picked);
                    },
                  ),
                ],
              ),
              CheckboxListTile(
                value: _ubicacion,
                onChanged: (v) => setState(() => _ubicacion = v ?? false),
                title: const Text('Activar ubicación'),
              ),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                icon: const Icon(Icons.sensors),
                label: const Text('Agregar sensor'),
                onPressed: _agregarSensor,
              ),
              ...sensores.map(
                (s) => ListTile(title: Text('${s['tipo']}: ${s['valor']}')),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: _guardarPaquete,
          child: const Text('Guardar paquete'),
        ),
      ],
    );
  }
}

class NewSensorDialog extends StatefulWidget {
  const NewSensorDialog({super.key});

  @override
  State<NewSensorDialog> createState() => _NewSensorDialogState();
}

class _NewSensorDialogState extends State<NewSensorDialog> {
  String? _tipo;
  final TextEditingController _valorController = TextEditingController();

  void _guardarSensor() {
    if (_tipo != null && _valorController.text.isNotEmpty) {
      Navigator.pop(context, {"tipo": _tipo!, "valor": _valorController.text});
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Agregar sensor'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<String>(
            value: _tipo,
            items: const [
              DropdownMenuItem(
                value: 'Temperatura',
                child: Text('Temperatura'),
              ),
              DropdownMenuItem(value: 'Humedad', child: Text('Humedad')),
              DropdownMenuItem(value: 'CO2', child: Text('CO2')),
              DropdownMenuItem(value: 'Otro', child: Text('Otro')),
            ],
            onChanged: (v) => setState(() => _tipo = v),
            decoration: const InputDecoration(labelText: 'Tipo de sensor'),
            validator: (v) => v == null ? 'Seleccione un tipo' : null,
          ),
          TextFormField(
            controller: _valorController,
            decoration: const InputDecoration(
              labelText: 'Valor deseado (ej: 22°C, 60%)',
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(onPressed: _guardarSensor, child: const Text('Agregar')),
      ],
    );
  }
}
