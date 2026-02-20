import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/device_provider.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<DeviceProvider>(
      builder: (context, provider, _) {
        final history = provider.metricsHistory.isEmpty 
            ? provider.metricsHistory 
            : provider.metricsHistory.reversed.toList();

        if (history.isEmpty) {
          return const Center(child: Text('No history data available'));
        }

        return ListView.builder(
          itemCount: history.length,
          itemBuilder: (context, index) {
            final metrics = history[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: ExpansionTile(
                title: Text(
                  metrics.timestamp.toString(),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Row(
                  children: [
                    _buildBadge('Temp: ${metrics.temperature.toStringAsFixed(1)}°C', Colors.red),
                    const SizedBox(width: 8),
                    _buildBadge('Battery: ${metrics.batteryLevel}%', Colors.green),
                  ],
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoRow('Device Model', metrics.deviceModel),
                        _buildInfoRow('Manufacturer', metrics.manufacturer),
                        _buildInfoRow('Android Version', metrics.androidVersion),
                        const Divider(),
                        _buildInfoRow('Temperature', '${metrics.temperature.toStringAsFixed(2)}°C'),
                        _buildInfoRow('Battery Level', '${metrics.batteryLevel}%'),
                        _buildInfoRow('Battery Health', metrics.batteryHealth),
                        _buildInfoRow('CPU Usage', '${metrics.cpuUsage.toStringAsFixed(2)}%'),
                        _buildInfoRow('RAM Usage', '${metrics.ramUsage.toStringAsFixed(2)}%'),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(value, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}