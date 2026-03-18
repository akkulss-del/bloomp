import 'package:flutter/material.dart';

import 'tech_models_screen.dart';

class TechSelectionScreen extends StatelessWidget {
  final String type;

  const TechSelectionScreen({super.key, required this.type});

  static const Map<String, List<Map<String, String>>> _techBrands = {
    'Спецтехника': [
      {'name': 'JCB', 'logo': '🚜'},
      {'name': 'CAT', 'logo': '🏗️'},
      {'name': 'Komatsu', 'logo': '🇯🇵'},
      {'name': 'Volvo', 'logo': '🇸🇪'},
      {'name': 'Bobcat', 'logo': '🐾'},
      {'name': 'Hitachi', 'logo': '🚜'},
    ],
    'Мототехника': [
      {'name': 'Yamaha', 'logo': '🎹'},
      {'name': 'Honda', 'logo': '🏍️'},
      {'name': 'Kawasaki', 'logo': '🟢'},
      {'name': 'BMW', 'logo': '🇩🇪'},
      {'name': 'Suzuki', 'logo': '🇯🇵'},
      {'name': 'Harley', 'logo': '🇺🇸'},
    ],
  };

  @override
  Widget build(BuildContext context) {
    final brands = _techBrands[type] ?? [];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      appBar: AppBar(
        title: Text(
          type,
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: brands.isEmpty
          ? const Center(child: Text("Нет марок для выбранного типа"))
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 0.9,
              ),
              itemCount: brands.length,
              itemBuilder: (context, index) {
                final brand = brands[index];
                return _buildBrandCard(context, brand);
              },
            ),
    );
  }

  Widget _buildBrandCard(BuildContext context, Map<String, String> brand) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TechModelsScreen(
            techType: type,
            brandName: brand['name']!,
          ),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black.withOpacity(0.04)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(brand['logo']!, style: const TextStyle(fontSize: 28)),
            const SizedBox(height: 6),
            Text(
              brand['name']!,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
