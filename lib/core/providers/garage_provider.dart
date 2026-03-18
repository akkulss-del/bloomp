import 'package:flutter/material.dart';

import '../../shared/models/garage_vehicle.dart';
import '../../shared/models/my_vehicle.dart';
import '../services/garage_service.dart';

class GarageProvider with ChangeNotifier {
  final GarageService _garageService = GarageService();

  MyVehicle? _selectedVehicle;
  MyVehicle? get selectedVehicle => _selectedVehicle;

  GarageProvider() {
    _loadSelected();
  }

  Future<void> _loadSelected() async {
    final vehicles = await _garageService.getVehicles();
    final def = vehicles.where((v) => v.isDefault).toList();
    final v = def.isNotEmpty ? def.first : (vehicles.isNotEmpty ? vehicles.first : null);
    if (v != null) {
      _selectedVehicle = MyVehicle(brand: v.brand, model: v.model, year: v.year);
      notifyListeners();
    }
  }

  void saveVehicle(MyVehicle vehicle) {
    _selectedVehicle = vehicle;
    final gv = GarageVehicle(
      vin: 'manual_${vehicle.brand}_${vehicle.model}_${vehicle.year}',
      brand: vehicle.brand,
      model: vehicle.model,
      year: vehicle.year,
      isDefault: true,
    );
    _garageService.saveVehicle(gv);
    notifyListeners();
  }

  void saveVehicleFromVin(String vin, MyVehicle decoded) {
    _selectedVehicle = decoded;
    final gv = GarageVehicle(
      vin: vin,
      brand: decoded.brand,
      model: decoded.model,
      year: decoded.year,
      isDefault: true,
    );
    _garageService.saveVehicle(gv);
    notifyListeners();
  }
}
