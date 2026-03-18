import 'package:flutter/material.dart';
import '../../catalog/auto_categories.dart';
import '../../catalog/mock_data.dart';
import '../../catalog/screens/category_products_screen.dart';

class CategoryCard extends StatelessWidget {
  final String? title;
  final int? index;

  const CategoryCard({super.key, this.title, this.index});

  String get _displayTitle {
    if (title != null) return title!;
    final idx = (index ?? 0) % autoCategories.length;
    return autoCategories[idx]['name'] ?? 'Категория';
  }

  String? get _iconPath {
    final idx = (index ?? 0) % autoCategories.length;
    final icon = autoCategories[idx]['icon'];
    return icon != null ? 'assets/parts/$icon' : null;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final products = MockData.getProductsByCategory(_displayTitle);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategoryProductsScreen(
              categoryName: _displayTitle,
              products: products,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF5F7FA),
          borderRadius: BorderRadius.circular(8),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            Positioned(
              top: 6,
              left: 6,
              right: 6,
              child: Text(
                _displayTitle,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  height: 1.1,
                ),
                maxLines: 2,
              ),
            ),
            Positioned(
              bottom: -2,
              right: -2,
              child: SizedBox(
                width: 70,
                height: 70,
                child: _iconPath != null
                    ? Image.asset(
                        _iconPath!,
                        fit: BoxFit.contain,
                        alignment: Alignment.bottomRight,
                        errorBuilder: (_, __, ___) => Icon(
                          Icons.category_outlined,
                          size: 48,
                          color: Colors.grey[400],
                        ),
                      )
                    : Icon(
                        Icons.category_outlined,
                        size: 48,
                        color: Colors.grey[400],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
