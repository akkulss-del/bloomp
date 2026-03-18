class GarageVehicle {
  final String vin;
  final String brand;
  final String model;
  final String year;
  final bool isDefault; // Главная машина в гараже

  GarageVehicle({
    required this.vin,
    required this.brand,
    required this.model,
    required this.year,
    this.isDefault = false,
  });
}
