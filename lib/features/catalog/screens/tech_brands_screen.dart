import 'package:flutter/material.dart';

import 'tech_models_screen.dart';

class TechBrandsScreen extends StatelessWidget {
  const TechBrandsScreen({super.key});

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
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      appBar: AppBar(
        title: const Text(
          "Спец- и мототехника",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.only(bottom: 20),
        itemCount: _techBrands.length,
        itemBuilder: (context, index) {
          final category = _techBrands.keys.elementAt(index);
          final brands = _techBrands[category]!;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
                child: Text(
                  category,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 85,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: brands.length,
                  itemBuilder: (context, bIndex) {
                    final brand = brands[bIndex];
                    return _buildBrandCard(context, brand, category);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBrandCard(BuildContext context, Map<String, String> brand, String category) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TechModelsScreen(
            techType: category,
            brandName: brand['name']!,
          ),
        ),
      ),
      child: Container(
        width: 75,
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black.withOpacity(0.04)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(brand['logo']!, style: const TextStyle(fontSize: 22)),
            const SizedBox(height: 4),
            Text(
              brand['name']!,
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
