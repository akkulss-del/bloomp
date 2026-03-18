import 'package:flutter/material.dart';

import '../../../core/data/mock_products.dart';
import '../mock_data.dart';
import 'category_products_screen.dart';

class TechModelsScreen extends StatefulWidget {
  final String techType;
  final String brandName;

  const TechModelsScreen({super.key, required this.techType, required this.brandName});

  @override
  State<TechModelsScreen> createState() => _TechModelsScreenState();
}

class _TechModelsScreenState extends State<TechModelsScreen> {
  static const Map<String, Map<String, List<String>>> _modelsByTechBrand = {
    'Спецтехника': {
      'JCB': ['3CX', '4CX', '5C', 'JS220', 'JS330', 'Loadall'],
      'CAT': ['D6', 'D8', '320', '330', '950M', '966M'],
      'Komatsu': ['PC200', 'PC300', 'D65', 'WA380', 'HD785'],
      'Volvo': ['EC140', 'EC240', 'L90', 'A25G', 'L220'],
      'Bobcat': ['S70', 'S450', 'S650', 'E35', 'T76'],
      'Hitachi': ['ZX200', 'ZX350', 'EX120', 'EX360'],
    },
    'Мототехника': {
      'Yamaha': ['YZF-R1', 'MT-07', 'MT-09', 'FZ1', 'Tracer', 'XSR900'],
      'Honda': ['CBR650R', 'CB650R', 'Africa Twin', 'Gold Wing', 'CRF450'],
      'Kawasaki': ['Ninja 400', 'Z900', 'Versys', 'Z650', 'ZX-10R'],
      'BMW': ['GS 1250', 'S1000RR', 'R1250RT', 'F850GS', 'K1600'],
      'Suzuki': ['GSX-R1000', 'V-Strom', 'Boulevard', 'DR650', 'Hayabusa'],
      'Harley': ['Street Glide', 'Road King', 'Sportster', 'Fat Boy', 'Softail'],
    },
  };

  List<String> get _models {
    final brands = _modelsByTechBrand[widget.techType];
    if (brands == null) return ['Модель 1', 'Модель 2', 'Модель 3'];
    return brands[widget.brandName] ?? ['Модель 1', 'Модель 2', 'Модель 3'];
  }

  void _selectModel(String model) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CategoryProductsScreen(
          categoryName: '${widget.brandName} $model (${widget.techType})',
          products: MockData.getProducts(),
        ),
      ),
    );
  }

  void _openSerialInput() {
    String title = '';
    String hint = '';
    if (widget.techType == 'Спецтехника') {
      title = 'Серийный номер или PIN';
      hint = 'Введите номер';
    } else {
      title = 'Номер рамы (Frame No)';
      hint = 'Введите номер рамы';
    }

    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(hintText: hint),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Отмена"),
          ),
          ElevatedButton(
            onPressed: () {
              final value = controller.text.trim();
              Navigator.pop(context);
              if (value.isNotEmpty) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CategoryProductsScreen(
                      categoryName: '${widget.brandName} $value (${widget.techType})',
                      products: MockData.getProducts(),
                    ),
                  ),
                );
              }
            },
            child: const Text("Найти"),
          ),
        ],
      ),
    );
  }

  Widget _buildFastSearchActionCard(String title, String sub, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F7FF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                Text(sub, style: const TextStyle(fontSize: 11, color: Colors.blueGrey)),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: _openSerialInput,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text("Ввести", style: TextStyle(color: Colors.white, fontSize: 12)),
          ),
        ],
      ),
    );
  }

  Widget _buildTopModelsGrid() {
    final topModels = _models.take(6).toList();
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 2.6,
      ),
      itemCount: topModels.length,
      itemBuilder: (context, index) => OutlinedButton(
        onPressed: () => _selectModel(topModels[index]),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: Colors.grey[200]!),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: Text(
          topModels[index],
          style: const TextStyle(fontSize: 11, color: Colors.black87, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  void _showAllModels() {
    final sorted = List<String>.from(_models)..sort();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        height: MediaQuery.of(context).size.height * 0.7,
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                "Все модели ${widget.brandName}",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: ListView.separated(
                itemCount: sorted.length,
                separatorBuilder: (_, __) => Divider(color: Colors.grey[100]),
                itemBuilder: (context, index) => ListTile(
                  title: Text(sorted[index], style: const TextStyle(fontWeight: FontWeight.w500)),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
                  onTap: () {
                    Navigator.pop(context);
                    _selectModel(sorted[index]);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShowAllButton() {
    if (_models.length <= 6) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Center(
        child: TextButton.icon(
          onPressed: _showAllModels,
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.blue, size: 18),
          label: const Text(
            "Все модели",
            style: TextStyle(fontSize: 13, color: Colors.blue, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _buildUniversalTechGrid() {
    String fastSearchTitle = "";
    String fastSearchSub = "";
    IconData fastSearchIcon = Icons.qr_code_scanner;

    if (widget.techType == 'Спецтехника') {
      fastSearchTitle = "Серийный номер или PIN?";
      fastSearchSub = "Поиск по каталогам производителей";
      fastSearchIcon = Icons.settings_input_component;
    } else if (widget.techType == 'Мототехника') {
      fastSearchTitle = "Номер рамы (Frame No)?";
      fastSearchSub = "Для точного подбора запчастей";
      fastSearchIcon = Icons.two_wheeler;
    }

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFastSearchActionCard(fastSearchTitle, fastSearchSub, fastSearchIcon),
          const SizedBox(height: 16),
          Text(
            "Популярные модели ${widget.brandName}:",
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.grey),
          ),
          const SizedBox(height: 10),
          _buildTopModelsGrid(),
          _buildShowAllButton(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      appBar: AppBar(
        title: Text(widget.brandName),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: _buildUniversalTechGrid(),
      ),
    );
  }
}
