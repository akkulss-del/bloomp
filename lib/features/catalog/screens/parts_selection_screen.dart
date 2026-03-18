import 'package:flutter/material.dart';

import 'product_list_screen.dart';

class PartsSelectionScreen extends StatefulWidget {
  final String carInfo;

  const PartsSelectionScreen({super.key, required this.carInfo});

  @override
  State<PartsSelectionScreen> createState() => _PartsSelectionScreenState();
}

class _PartsSelectionScreenState extends State<PartsSelectionScreen> {
  bool showUsed = false;

  static const List<String> _partCategories = [
    'Двигатель',
    'Трансмиссия',
    'Кузовные',
    'Подвеска',
    'Рулевое',
    'Тормозная',
    'Оптика',
    'Электрика',
    'Охлаждение',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.carInfo,
              style: const TextStyle(fontSize: 16, color: Colors.black),
            ),
            const Text(
              'Выберите категорию запчастей',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
          _buildTypeToggle(),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 0.75,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              ),
              itemCount: _partCategories.length,
              itemBuilder: (context, index) => _buildPartCategoryCard(index),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeToggle() {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          _toggleButton('Новые', !showUsed),
          _toggleButton('Б/У Запчасти', showUsed),
        ],
      ),
    );
  }

  Widget _toggleButton(String text, bool isActive) {
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => showUsed = !showUsed),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isActive ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            boxShadow: isActive
                ? [BoxShadow(color: Colors.black12, blurRadius: 4)]
                : [],
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isActive ? Colors.blue : Colors.grey,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPartCategoryCard(int index) {
    final currentCat = _partCategories[index];

    return GestureDetector(
      onTap: () => _openCategory(currentCat),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: showUsed
              ? Border.all(color: Colors.orange.withOpacity(0.3))
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (showUsed)
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  margin: const EdgeInsets.only(left: 4, top: 4),
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'РАЗБОР',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            const Icon(Icons.settings_suggest, size: 30, color: Colors.blueGrey),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                currentCat,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openCategory(String partCategory) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductListScreen(
          carModel: widget.carInfo,
          category: partCategory,
          initialFilterIndex: showUsed ? 2 : 0,
        ),
      ),
    );
  }
}
