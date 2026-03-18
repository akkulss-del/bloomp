import 'package:flutter/material.dart';

import 'car_models_screen.dart';

class CarBrandsScreen extends StatefulWidget {
  const CarBrandsScreen({super.key});

  @override
  State<CarBrandsScreen> createState() => _CarBrandsScreenState();
}

class _CarBrandsScreenState extends State<CarBrandsScreen> {
  final Map<String, List<Map<String, String>>> _allBrandsByCountry = {
    'Немецкие': [
      {'name': 'BMW', 'logo': '🇩🇪'},
      {'name': 'Mercedes', 'logo': '🇩🇪'},
      {'name': 'Audi', 'logo': '🇩🇪'},
      {'name': 'Porsche', 'logo': '🇩🇪'},
    ],
    'Японские': [
      {'name': 'Toyota', 'logo': '🇯🇵'},
      {'name': 'Lexus', 'logo': '🇯🇵'},
      {'name': 'Nissan', 'logo': '🇯🇵'},
      {'name': 'Mazda', 'logo': '🇯🇵'},
    ],
    'Китайские': [
      {'name': 'Geely', 'logo': '🇨🇳'},
      {'name': 'Haval', 'logo': '🇨🇳'},
      {'name': 'Changan', 'logo': '🇨🇳'},
      {'name': 'Zeekr', 'logo': '🇨🇳'},
    ],
    'Корейские': [
      {'name': 'Hyundai', 'logo': '🇰🇷'},
      {'name': 'Kia', 'logo': '🇰🇷'},
      {'name': 'Genesis', 'logo': '🇰🇷'},
    ],
  };

  Map<String, List<Map<String, String>>> _filteredBrands = {};
  String _searchQuery = "";

  final List<Map<String, String>> _popularBrands = [
    {'name': 'Toyota', 'logo': '🇯🇵'},
    {'name': 'BMW', 'logo': '🇩🇪'},
    {'name': 'Mercedes', 'logo': '🇩🇪'},
    {'name': 'Lexus', 'logo': '🇯🇵'},
    {'name': 'Hyundai', 'logo': '🇰🇷'},
    {'name': 'Kia', 'logo': '🇰🇷'},
  ];

  @override
  void initState() {
    super.initState();
    _filteredBrands = Map.from(_allBrandsByCountry);
  }

  void _filterBrands(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _filteredBrands = Map.from(_allBrandsByCountry);
      } else {
        final tempMap = <String, List<Map<String, String>>>{};
        _allBrandsByCountry.forEach((country, brands) {
          final filteredList = brands
              .where((brand) => brand['name']!.toLowerCase().contains(query.toLowerCase()))
              .toList();
          if (filteredList.isNotEmpty) {
            tempMap[country] = filteredList;
          }
        });
        _filteredBrands = tempMap;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      appBar: AppBar(
        title: const Text(
          "Марка автомобиля",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: TextField(
              onChanged: _filterBrands,
              decoration: InputDecoration(
                hintText: "Поиск марки (например, Toyota)",
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: const Color(0xFFF2F3F5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),
          Expanded(
            child: _filteredBrands.isEmpty ? _buildEmptyState() : _buildMainBrandList(),
          ),
        ],
      ),
    );
  }

  Widget _buildMainBrandList() {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 20),
      itemCount: _filteredBrands.length,
      itemBuilder: (context, index) {
        final country = _filteredBrands.keys.elementAt(index);
        final brands = _filteredBrands[country]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    country,
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  GestureDetector(
                    onTap: () => _showAllBrandsForCountry(country, brands),
                    child: const Text(
                      "Все",
                      style: TextStyle(color: Color(0xFF2E6FF2), fontSize: 12),
                    ),
                  ),
                ],
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
                  return _buildSmallBrandCard(context, brand);
                },
              ),
            ),
          ],
        );
      },
    );
  }

  void _showAllBrandsForCountry(String country, List<Map<String, String>> brands) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => ListView.builder(
        shrinkWrap: true,
        padding: const EdgeInsets.all(20),
        itemCount: brands.length,
        itemBuilder: (context, index) {
          final brand = brands[index];
          return ListTile(
            leading: Text(brand['logo']!, style: const TextStyle(fontSize: 24)),
            title: Text(brand['name']!),
            trailing: const Icon(Icons.arrow_forward_ios, size: 14),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CarModelsScreen(brandName: brand['name']!),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildSmallBrandCard(BuildContext context, Map<String, String> brand) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CarModelsScreen(brandName: brand['name']!),
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            "Марка не найдена",
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}
