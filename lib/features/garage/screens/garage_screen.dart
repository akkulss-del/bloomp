import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/providers/garage_provider.dart';
import '../../../shared/models/my_vehicle.dart';
import 'add_vehicle_screen.dart';

class GarageScreen extends StatelessWidget {
  const GarageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vehicle = context.watch<GarageProvider>().selectedVehicle;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Мой гараж'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: vehicle == null
          ? _buildEmptyState(context)
          : _buildVehicleCard(context, vehicle),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AddVehicleScreen()),
        ),
        backgroundColor: const Color(0xFFF91155),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.garage_outlined, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'Нет автомобилей',
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddVehicleScreen()),
            ),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFF91155)),
            child: const Text('Добавить автомобиль', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildVehicleCard(BuildContext context, MyVehicle vehicle) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: ListTile(
          leading: const CircleAvatar(
            backgroundColor: Color(0xFFF91155),
            child: Icon(Icons.directions_car, color: Colors.white),
          ),
          title: Text('${vehicle.brand} ${vehicle.model}', style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(vehicle.year),
          trailing: IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddVehicleScreen()),
            ),
          ),
        ),
      ),
    );
  }
}
