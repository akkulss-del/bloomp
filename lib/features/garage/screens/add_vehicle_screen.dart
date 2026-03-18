import 'package:flutter/material.dart';

import '../../catalog/screens/add_to_garage_screen.dart';

/// Обёртка над AddToGarageScreen для совместимости с маршрутами.
class AddVehicleScreen extends StatelessWidget {
  const AddVehicleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AddToGarageScreen();
  }
}
