import 'package:flutter/material.dart';

class BannerGridScreen extends StatelessWidget {
  const BannerGridScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> banners = [
      {'title': 'АКЦИЯ 1', 'color': Colors.blue.shade100},
      {'title': 'АКЦИЯ 2', 'color': Colors.blue.shade200},
      {'title': 'АКЦИЯ 3', 'color': Colors.blue.shade300},
      {'title': 'АКЦИЯ 4', 'color': Colors.blue.shade400},
      {'title': 'АКЦИЯ 5', 'color': Colors.blue.shade500},
      {'title': 'АКЦИЯ 6', 'color': Colors.blue.shade600},
      {'title': 'АКЦИЯ 7', 'color': Colors.blue.shade700},
      {'title': 'АКЦИЯ 8', 'color': Colors.blue.shade800},
      {'title': 'АКЦИЯ 9', 'color': Colors.blue.shade900},
      {'title': 'АКЦИЯ 10', 'color': const Color(0xFF2E6FF2)},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Рекламные Баннеры",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      backgroundColor: const Color(0xFFF2F3F5),
      body: GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.6,
        ),
        itemCount: banners.length,
        itemBuilder: (context, index) {
          final banner = banners[index];
          final color = banner['color'] as Color;
          return Container(
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Center(
                child: Text(
                  banner['title'] as String,
                  style: TextStyle(
                    color: color.computeLuminance() > 0.5 ? Colors.black87 : Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
