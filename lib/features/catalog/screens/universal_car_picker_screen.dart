import 'package:flutter/material.dart';

import 'parts_selection_screen.dart';

class UniversalCarPicker extends StatefulWidget {
  final String category;
  final String? region;

  const UniversalCarPicker({
    super.key,
    required this.category,
    this.region,
  });

  @override
  State<UniversalCarPicker> createState() => _UniversalCarPickerState();
}

class _UniversalCarPickerState extends State<UniversalCarPicker> {
  int step = 0;
  String? brand;
  String? model;
  String? year;

  static const Map<String, List<String>> _regionBrands = {
    'Китай': ['Geely', 'Haval', 'Chery', 'Changan', 'Exeed', 'BYD', 'Zeekr', 'Li Auto', 'Voyah'],
    'Германия': ['BMW', 'Mercedes', 'Audi', 'VW', 'Porsche', 'Opel'],
    'Япония': ['Toyota', 'Honda', 'Nissan', 'Mazda', 'Mitsubishi', 'Subaru', 'Lexus', 'Suzuki'],
    'Корея': ['Hyundai', 'Kia', 'Genesis', 'SsangYong', 'Daewoo'],
    'США': ['Ford', 'Chevrolet', 'Tesla', 'Jeep', 'Dodge', 'Cadillac', 'GMC'],
    'Европа': ['BMW', 'Mercedes', 'Audi', 'VW', 'Renault', 'Peugeot', 'Fiat', 'Volvo'],
  };

  static const Map<String, List<String>> _brandModels = {
    'Geely': ['Monjaro', 'Tugella', 'Coolray', 'Atlas Pro', 'Okavango', 'Emgrand', 'Geometry'],
    'Haval': ['F7', 'F7x', 'H6', 'Jolion', 'M6', 'H9'],
    'Chery': ['Tiggo 7', 'Tiggo 8', 'Omoda 5', 'Exlantix', 'Arrizo'],
    'BMW': ['3 Series', '5 Series', 'X3', 'X5', 'X7'],
    'Mercedes': ['C-Class', 'E-Class', 'GLC', 'GLE', 'S-Class'],
    'Audi': ['A4', 'A6', 'Q5', 'Q7', 'e-tron'],
    'VW': ['Passat', 'Tiguan', 'Polo', 'Golf', 'Touareg'],
    'Ford': ['Focus', 'Explorer', 'F-150', 'Mustang', 'Bronco'],
    'Tesla': ['Model 3', 'Model Y', 'Model S', 'Model X', 'Cybertruck'],
    'Toyota': ['Camry', 'Corolla', 'RAV4', 'Land Cruiser', 'Hilux'],
    'Honda': ['CR-V', 'Accord', 'Civic', 'Pilot', 'HR-V'],
    'Hyundai': ['Tucson', 'Santa Fe', 'Sonata', 'Palisade', 'Kona'],
  };

  List<String> get _brands {
    if (widget.region != null && _regionBrands.containsKey(widget.region)) {
      return _regionBrands[widget.region]!;
    }
    return _regionBrands.values.expand((e) => e).toSet().toList();
  }

  List<String> get _models => _brandModels[brand ?? ''] ?? ['Atlas Pro', 'Coolray', 'Monjaro', 'Okavango', 'Tugella'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      appBar: AppBar(
        title: Text(brand ?? 'Выберите марку'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(40),
          child: _buildBreadcrumbs(),
        ),
      ),
      body: _buildListByStep(),
    );
  }

  Widget _buildBreadcrumbs() {
    final parts = <String>[widget.category];
    if (brand != null) parts.add(brand!);
    if (model != null) parts.add(model!);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      alignment: Alignment.centerLeft,
      child: Text(
        parts.join(' > '),
        style: const TextStyle(fontSize: 12, color: Colors.blue),
      ),
    );
  }

  Widget _buildListByStep() {
    switch (step) {
      case 0:
        return _brandGrid();
      case 1:
        return _modelList();
      case 2:
        return _yearGrid();
      default:
        return const Center(child: CircularProgressIndicator());
    }
  }

  Widget _brandGrid() {
    final brands = _brands;
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
      ),
      itemCount: brands.length,
      itemBuilder: (context, index) => InkWell(
        onTap: () => setState(() {
          brand = brands[index];
          step = 1;
        }),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 6,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: Colors.grey[100],
                child: Icon(Icons.directions_car, color: Colors.blueGrey[400]),
              ),
              const SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  brands[index],
                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _modelList() {
    final models = _models;
    return Container(
      color: Colors.white,
      child: ListView.separated(
        itemCount: models.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) => ListTile(
          title: Text(
            models[index],
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
          onTap: () => setState(() {
            model = models[index];
            step = 2;
          }),
        ),
      ),
    );
  }

  Widget _yearGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3,
      ),
      itemCount: 20,
      itemBuilder: (context, index) {
        final y = 2026 - index;
        return ActionChip(
          label: Text('$y г.в.'),
          onPressed: () {
            year = '$y';
            _openPartsCatalog();
          },
        );
      },
    );
  }

  void _openPartsCatalog() {
    final carInfo = '$brand $model ${year ?? ''}'.trim();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PartsSelectionScreen(carInfo: carInfo),
      ),
    );
  }
}
