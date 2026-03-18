import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/providers/garage_provider.dart';
import '../../../shared/models/my_vehicle.dart';
import '../../catalog/car_data.dart';
import '../../catalog/widgets/toyota_model_picker.dart';
import '../../services/screens/vin_scanner_screen.dart';
import 'car_selection_flow_screen.dart';

class AddToGarageScreen extends StatefulWidget {
  const AddToGarageScreen({super.key});

  @override
  State<AddToGarageScreen> createState() => _AddToGarageScreenState();
}

class _AddToGarageScreenState extends State<AddToGarageScreen> {
  final TextEditingController _vinController = TextEditingController();

  @override
  void dispose() {
    _vinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      appBar: AppBar(
        title: const Text("Добавить автомобиль"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Введите VIN-код (17 символов)",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _vinController,
              maxLength: 17,
              textCapitalization: TextCapitalization.characters,
              decoration: InputDecoration(
                hintText: "XTA211000...",
                filled: true,
                fillColor: Colors.grey[100],
                suffixIcon: IconButton(
                  icon: const Icon(Icons.camera_alt_outlined, color: Color(0xFF2E6FF2)),
                  onPressed: () => _openVinScanner(context),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "VIN-код указан в техпаспорте или под лобовым стеклом. Он поможет нам подобрать запчасти со 100% точностью.",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const Spacer(),
            OutlinedButton.icon(
              onPressed: () => _onToyotaTap(context),
              icon: const Icon(Icons.directions_car, size: 20),
              label: const Text('Быстрый выбор Toyota'),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF2E6FF2),
                side: const BorderSide(color: Color(0xFF2E6FF2)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E6FF2),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _saveAndGoBack,
                child: const Text("Найти машину", style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CarSelectionFlow()),
                  );
                },
                child: const Text("У меня нет VIN-кода", style: TextStyle(color: Colors.grey)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onToyotaTap(BuildContext context) async {
    final selectedModel = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ToyotaModelPicker(
        brandName: 'Toyota',
        models: CarData.toyotaModels,
      ),
    );

    if (selectedModel != null && context.mounted) {
      context.read<GarageProvider>().saveVehicle(
            MyVehicle(brand: 'Toyota', model: selectedModel, year: '—'),
          );
      if (context.mounted) Navigator.pop(context);
    }
  }

  void _openVinScanner(BuildContext context) async {
    final scannedVin = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (context) => const VinScannerScreen()),
    );

    if (scannedVin != null && mounted) {
      _vinController.text = scannedVin;
      _showSuccessDialog(context, scannedVin);
    }
  }

  void _showSuccessDialog(BuildContext context, String vin) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green[600], size: 28),
            const SizedBox(width: 8),
            const Text("Машина найдена!"),
          ],
        ),
        content: Text("VIN: $vin"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  void _saveAndGoBack() {
    final vin = _vinController.text.trim();
    if (vin.length == 17) {
      // TODO: Расшифровать VIN через API
      context.read<GarageProvider>().saveVehicleFromVin(
            vin,
            MyVehicle(brand: "По VIN", model: vin, year: "—"),
          );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Введите корректный VIN (17 символов)"),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}
