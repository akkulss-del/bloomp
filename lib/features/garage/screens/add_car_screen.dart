import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/providers/garage_provider.dart';
import '../../../shared/models/my_vehicle.dart';
import '../../catalog/screens/car_selection_flow_screen.dart';

class AddCarScreen extends StatefulWidget {
  const AddCarScreen({super.key});

  @override
  State<AddCarScreen> createState() => _AddCarScreenState();
}

class _AddCarScreenState extends State<AddCarScreen> {
  final TextEditingController _vinController = TextEditingController();
  String _selectedBrand = 'Выберите марку';
  String _selectedModel = 'Выберите модель';
  String _selectedYear = 'Выберите год';
  String _selectedBody = 'Выберите тип кузова';

  Widget _buildSelectField(String label, String value, VoidCallback onTap) {
    return ListTile(
      title: Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
      subtitle: Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  void _openCarSelection() async {
    final result = await Navigator.push<CarSelectionResult>(
      context,
      MaterialPageRoute(
        builder: (context) => const CarSelectionFlow(forGarageSelection: true),
      ),
    );
    if (result != null && mounted) {
      setState(() {
        _selectedBrand = result.brand;
        _selectedModel = result.model;
        _selectedYear = result.year;
        _selectedBody = '${result.model} (${result.year})';
      });
    }
  }

  @override
  void dispose() {
    _vinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color brandBlue = Color(0xFF2E6FF2);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text("Добавление авто", style: TextStyle(color: Colors.black)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Поиск по VIN", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),
            TextField(
              controller: _vinController,
              decoration: InputDecoration(
                hintText: 'Введите 17 знаков VIN-кода',
                filled: true,
                fillColor: const Color(0xFFF2F3F5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search, color: brandBlue),
                  onPressed: () {
                    // TODO: Логика поиска по VIN
                  },
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Center(child: Text("ИЛИ", style: TextStyle(color: Colors.grey))),
            ),
            const Text("Выбор по параметрам", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.grey.withOpacity(0.2)),
              ),
              child: Column(
                children: [
                  _buildSelectField("Марка", _selectedBrand, _openCarSelection),
                  const Divider(height: 1),
                  _buildSelectField("Модель", _selectedModel, _openCarSelection),
                  const Divider(height: 1),
                  _buildSelectField("Год выпуска", _selectedYear, _openCarSelection),
                  const Divider(height: 1),
                  _buildSelectField("Кузов", _selectedBody, _openCarSelection),
                ],
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: brandBlue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  final brand = _selectedBrand != 'Выберите марку' ? _selectedBrand : null;
                  final model = _selectedModel != 'Выберите модель' ? _selectedModel : null;
                  final year = _selectedYear != 'Выберите год' ? _selectedYear : null;
                  if (brand == null || model == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Выберите марку и модель по параметрам'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                    return;
                  }
                  final vehicle = MyVehicle(
                    brand: brand,
                    model: model,
                    year: year ?? '—',
                  );
                  context.read<GarageProvider>().saveVehicle(vehicle);
                  Navigator.pop(context, '${vehicle.brand} ${vehicle.model}, ${vehicle.year}');
                },
                child: const Text("Сохранить в гараж", style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
