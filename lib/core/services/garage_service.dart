import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../shared/models/garage_vehicle.dart';

class GarageService {
  static const String _keyVehicles = 'garage_vehicles';

  Future<void> saveVehicle(GarageVehicle vehicle) async {
    final prefs = await SharedPreferences.getInstance();
    final list = await getVehicles();
    final filtered = list.where((v) => v.vin != vehicle.vin).toList();
    filtered.add(vehicle);
    await prefs.setString(_keyVehicles, jsonEncode(filtered.map((v) => _toMap(v)).toList()));
  }

  Future<List<GarageVehicle>> getVehicles() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(_keyVehicles);
    if (json == null) return [];
    final list = jsonDecode(json) as List<dynamic>;
    return list.map((e) => _fromMap(e as Map<String, dynamic>)).toList();
  }

  Map<String, dynamic> _toMap(GarageVehicle v) {
    return {
      'vin': v.vin,
      'brand': v.brand,
      'model': v.model,
      'year': v.year,
      'isDefault': v.isDefault,
    };
  }

  GarageVehicle _fromMap(Map<String, dynamic> m) {
    return GarageVehicle(
      vin: m['vin'] as String,
      brand: m['brand'] as String,
      model: m['model'] as String,
      year: m['year'] as String,
      isDefault: m['isDefault'] as bool? ?? false,
    );
  }
}
