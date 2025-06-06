import 'package:flutter/material.dart';
import 'package:flutter_agroroute/widgets/agroroute_scaffold.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DashboardScreen extends StatelessWidget {
  final int enTransito = 5;
  final int entregados = 1;
  final int retrasados = 1;

  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<ChartData> chartData = [
      ChartData('En tránsito', enTransito, const Color(0xFF42A5F5)),
      ChartData('Entregados', entregados, Colors.green),
      ChartData('Retrasados', retrasados, const Color(0xFFFFA000)),
    ];

    return AgroRouteScaffold(
      selectedIndex: 0, // Dashboard
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Dashboard General',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Sección de Envíos con gráfico circular
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Envíos',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        // Gráfico circular
                        SizedBox(
                          width: 150,
                          height: 150,
                          child: SfCircularChart(
                            series: <CircularSeries>[
                              DoughnutSeries<ChartData, String>(
                                dataSource: chartData,
                                xValueMapper: (ChartData data, _) =>
                                    data.category,
                                yValueMapper: (ChartData data, _) => data.value,
                                pointColorMapper: (ChartData data, _) =>
                                    data.color,
                                innerRadius: '60%',
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 20),
                        // Leyenda y cantidades
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildStatusIndicator(
                              'En tránsito',
                              enTransito,
                              const Color(0xFF42A5F5),
                            ),
                            const SizedBox(height: 8),
                            _buildStatusIndicator(
                              'Entregados',
                              entregados,
                              Colors.green,
                            ),
                            const SizedBox(height: 8),
                            _buildStatusIndicator(
                              'Retrasados',
                              retrasados,
                              const Color(0xFFFFA000),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Sección de Gestión de Alertas - CORREGIDA
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Gestión de alertas',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columns: const [
                          DataColumn(
                            label: Text(
                              'Alerta',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Acción',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Impacto',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                        rows: [
                          DataRow(
                            cells: [
                              DataCell(
                                Row(
                                  children: const [
                                    Icon(
                                      Icons.warning_amber_rounded,
                                      color: Colors.red,
                                      size: 20,
                                    ),
                                    SizedBox(width: 6),
                                    Text('Temperatura alta del riesgo (envío)'),
                                  ],
                                ),
                              ),
                              const DataCell(Text('Cambiar embalaje')),
                              const DataCell(Text('Alto')),
                            ],
                          ),
                          DataRow(
                            cells: [
                              DataCell(
                                Row(
                                  children: const [
                                    Icon(
                                      Icons.warning_amber_rounded,
                                      color: Colors.amber,
                                      size: 20,
                                    ),
                                    SizedBox(width: 6),
                                    Text('Humedad baja'),
                                  ],
                                ),
                              ),
                              const DataCell(Text('Ajustar humedad')),
                              const DataCell(Text('Medio')),
                            ],
                          ),
                          DataRow(
                            cells: [
                              DataCell(
                                Row(
                                  children: const [
                                    Icon(
                                      Icons.warning_amber_rounded,
                                      color: Colors.red,
                                      size: 20,
                                    ),
                                    SizedBox(width: 6),
                                    Text('Desviación de ruta'),
                                  ],
                                ),
                              ),
                              const DataCell(Text('Revisar GPS')),
                              const DataCell(Text('Alto')),
                            ],
                          ),
                          DataRow(
                            cells: [
                              DataCell(
                                Row(
                                  children: const [
                                    Icon(
                                      Icons.warning_amber_rounded,
                                      color: Colors.amber,
                                      size: 20,
                                    ),
                                    SizedBox(width: 6),
                                    Text('Retraso en entrega'),
                                  ],
                                ),
                              ),
                              const DataCell(Text('Verificar transporte')),
                              const DataCell(Text('Medio')),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Sección de Sensores
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Sensores',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildSensorCard(
                          'Sensor Temperatura',
                          '19 °C',
                          Icons.thermostat,
                        ),
                        _buildSensorCard(
                          'Sensor Humedad',
                          '10%',
                          Icons.water_drop,
                        ),
                        _buildSensorCard('GPS', 'Activo', Icons.gps_fixed),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusIndicator(String label, int count, Color color) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text('$label: $count'),
      ],
    );
  }

  Widget _buildSensorCard(String name, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 40, color: Colors.blue),
        const SizedBox(height: 8),
        Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(value),
      ],
    );
  }
}

class ChartData {
  final String category;
  final int value;
  final Color color;

  ChartData(this.category, this.value, this.color);
}
