import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'product_list_screen.dart';

/// Результат выбора авто для гаража
class CarSelectionResult {
  final String brand;
  final String model; // например "Atlas Pro (2020 - н.в.)"
  final String year;

  CarSelectionResult({required this.brand, required this.model, required this.year});
}

class CarSelectionFlow extends StatefulWidget {
  final String? region;
  /// Если true, при выборе поколения возвращает результат вместо перехода к каталогу
  final bool forGarageSelection;

  const CarSelectionFlow({super.key, this.region, this.forGarageSelection = false});

  @override
  State<CarSelectionFlow> createState() => _CarSelectionFlowState();
}

class _CarSelectionFlowState extends State<CarSelectionFlow> {
  int step = 0; // 0: Марка, 1: Поколение, 2: Категории
  String? selectedBrand;
  Map<String, dynamic>? selectedGeneration;

  static const Map<String, List<String>> _regionBrands = {
    'Китай': ['Geely', 'Haval', 'Chery', 'Changan', 'Exeed', 'BYD'],
    'Германия': ['BMW', 'Mercedes', 'Audi', 'VW', 'Porsche', 'Opel'],
    'Япония': ['Toyota', 'Honda', 'Nissan', 'Mazda', 'Mitsubishi', 'Subaru', 'Lexus', 'Suzuki'],
    'Корея': ['Hyundai', 'Kia', 'Genesis', 'SsangYong', 'Daewoo'],
    'США': ['Ford', 'Chevrolet', 'Tesla', 'Jeep', 'Dodge', 'Cadillac', 'GMC'],
    'Европа': ['BMW', 'Mercedes', 'Audi', 'VW', 'Renault', 'Peugeot', 'Fiat', 'Volvo'],
  };

  static const List<Map<String, String>> _carImages = [
    {'url': 'https://images.unsplash.com/photo-1621007947382-bb3c3994e3fb?w=600', 'name': 'Sedan'},
    {'url': 'https://images.unsplash.com/photo-1609521263047-f8f205293f24?w=600', 'name': 'SUV'},
    {'url': 'https://images.unsplash.com/photo-1618843479313-40f8afb4b4d8?w=600', 'name': 'Sedan2'},
    {'url': 'https://images.unsplash.com/photo-1551836022-d5d88e9218df?w=600', 'name': 'Car'},
  ];

  static const Map<String, List<Map<String, String>>> _generations = {
    'Geely': [
      {'title': 'Monjaro (2022 - н.в.)', 'img': 'https://images.unsplash.com/photo-1621007947382-bb3c3994e3fb?w=600'},
      {'title': 'Coolray (2019 - н.в.)', 'img': 'https://images.unsplash.com/photo-1609521263047-f8f205293f24?w=600'},
      {'title': 'Atlas Pro (2020 - н.в.)', 'img': 'https://images.unsplash.com/photo-1618843479313-40f8afb4b4d8?w=600'},
      {'title': 'Tugella (2020 - н.в.)', 'img': 'https://images.unsplash.com/photo-1551836022-d5d88e9218df?w=600'},
    ],
    'Toyota': [
      {'title': 'Camry XV70 (2017 - 2024)', 'img': 'https://images.unsplash.com/photo-1621007947382-bb3c3994e3fb?w=600'},
      {'title': 'RAV4 XA50 (2018 - н.в.)', 'img': 'https://images.unsplash.com/photo-1609521263047-f8f205293f24?w=600'},
      {'title': 'Land Cruiser J200 (2007 - 2021)', 'img': 'https://images.unsplash.com/photo-1618843479313-40f8afb4b4d8?w=600'},
      {'title': 'Corolla E210 (2018 - н.в.)', 'img': 'https://images.unsplash.com/photo-1551836022-d5d88e9218df?w=600'},
    ],
    'BMW': [
      {'title': '3 Series G20 (2018 - н.в.)', 'img': 'https://images.unsplash.com/photo-1621007947382-bb3c3994e3fb?w=600'},
      {'title': '5 Series G30 (2016 - н.в.)', 'img': 'https://images.unsplash.com/photo-1609521263047-f8f205293f24?w=600'},
      {'title': 'X5 G05 (2018 - н.в.)', 'img': 'https://images.unsplash.com/photo-1618843479313-40f8afb4b4d8?w=600'},
      {'title': 'X3 G01 (2017 - н.в.)', 'img': 'https://images.unsplash.com/photo-1551836022-d5d88e9218df?w=600'},
    ],
  };

  List<String> get _brands {
    if (widget.region != null && _regionBrands.containsKey(widget.region)) {
      return _regionBrands[widget.region]!;
    }
    return ['Geely', 'Toyota', 'BMW', 'Mercedes', 'Haval', 'Chery', 'Honda', 'Hyundai', 'Ford'];
  }

  List<Map<String, String>> get _generationList {
    return _generations[selectedBrand ?? ''] ??
        [
          {'title': 'Модель (2018 - н.в.)', 'img': _carImages[0]['url']!},
          {'title': 'Модель X (2015 - 2022)', 'img': _carImages[1]['url']!},
          {'title': 'Модель Y (2020 - н.в.)', 'img': _carImages[2]['url']!},
          {'title': 'Модель Z (2012 - 2019)', 'img': _carImages[3]['url']!},
        ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F3F5),
      appBar: AppBar(
        title: Text(_getStepTitle()),
        backgroundColor: Colors.white,
        elevation: 0.5,
        foregroundColor: Colors.black,
      ),
      body: _buildCurrentStep(),
    );
  }

  String _getStepTitle() {
    if (step == 0) return 'Выберите марку';
    if (step == 1) return 'Выберите поколение (кузов)';
    return 'Каталог деталей';
  }

  Widget _buildCurrentStep() {
    switch (step) {
      case 0:
        return _buildBrandGrid();
      case 1:
        return _buildGenerationList();
      case 2:
        return _buildPartsGrid();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildBrandGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 1,
      ),
      itemCount: _brands.length,
      itemBuilder: (context, index) => _buildSquareCard(
        _brands[index],
        Icons.directions_car,
        () => setState(() {
          selectedBrand = _brands[index];
          step = 1;
        }),
      ),
    );
  }

  Widget _buildGenerationList() {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: _generationList.length,
      itemBuilder: (context, index) {
        final gen = _generationList[index];
        return _buildGenerationCard(gen['title']!, gen['img']!, index);
      },
    );
  }

  void _onGenerationSelected(String title, String imageUrl) {
    if (widget.forGarageSelection) {
      final model = title.contains('(') ? title.split('(')[0].trim() : title;
      final yearMatch = RegExp(r'\(([^)]+)\)').firstMatch(title);
      final year = yearMatch?.group(1) ?? '—';
      Navigator.pop(context, CarSelectionResult(
        brand: selectedBrand ?? '',
        model: model,
        year: year,
      ));
    } else {
      setState(() {
        selectedGeneration = {'title': title, 'img': imageUrl};
        step = 2;
      });
    }
  }

  Widget _buildGenerationCard(String title, String imageUrl, int index) {
    return InkWell(
      onTap: () => _onGenerationSelected(title, imageUrl),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        height: 180,
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 12)],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            fit: StackFit.expand,
            children: [
              CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(
                  color: Colors.grey[200],
                  child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                ),
                errorWidget: (_, __, ___) => Container(
                  color: Colors.grey[300],
                  child: const Icon(Icons.directions_car, size: 60, color: Colors.grey),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Colors.black.withOpacity(0.7), Colors.transparent],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static const List<Map<String, dynamic>> _partsCategories = [
    {'t': 'Расходники ТО', 'i': Icons.filter_alt, 'c': Color(0xFFE3F2FD)},
    {'t': 'Тормоза', 'i': Icons.stop_circle, 'c': Color(0xFFFFEBEE)},
    {'t': 'Масла', 'i': Icons.oil_barrel, 'c': Color(0xFFFFF8E1)},
    {'t': 'Подвеска', 'i': Icons.shutter_speed, 'c': Color(0xFFE8F5E9)},
    {'t': 'Двигатель', 'i': Icons.settings, 'c': Color(0xFFEEEEEE)},
    {'t': 'Б/У Запчасти', 'i': Icons.recycling, 'c': Color(0xFFFFF3E0)},
  ];

  Widget _buildPartsGrid() {
    final carModel = '${selectedBrand ?? ''} ${selectedGeneration?['title'] ?? ''}'.trim();
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 1,
      ),
      itemCount: _partsCategories.length,
      itemBuilder: (context, index) {
        final item = _partsCategories[index];
        final isUsed = item['t'] == 'Б/У Запчасти';
        return _buildSquareCard(
          item['t'] as String,
          item['i'] as IconData,
          () => _onPartCategoryTap(carModel, item['t'] as String, isUsed),
          color: item['c'] as Color,
        );
      },
    );
  }

  void _onPartCategoryTap(String carModel, String category, bool isUsed) {
    if (isUsed) {
      Navigator.pushNamed(context, '/used-parts');
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductListScreen(
          carModel: carModel,
          category: category,
          initialFilterIndex: isUsed ? 2 : 0,
        ),
      ),
    );
  }

  Widget _buildSquareCard(String title, IconData icon, VoidCallback onTap, {Color? color}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        decoration: BoxDecoration(
          color: color ?? Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 30, color: Colors.black54),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
