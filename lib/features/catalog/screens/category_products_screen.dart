import 'package:flutter/material.dart';

import '../../../shared/models/product.dart';
import '../../home/widgets/product_card_item.dart';

enum SortType { cheapFirst, expensiveFirst, popular }

class CategoryProductsScreen extends StatefulWidget {
  final String categoryName;
  final List<Product> products;
  final String? compatibleWith;

  const CategoryProductsScreen({
    super.key,
    required this.categoryName,
    required this.products,
    this.compatibleWith,
  });

  @override
  State<CategoryProductsScreen> createState() => _CategoryProductsScreenState();
}

class _CategoryProductsScreenState extends State<CategoryProductsScreen> {
  SortType _currentSort = SortType.popular;

  List<Product> get _sortedProducts {
    final list = List<Product>.from(widget.products);
    switch (_currentSort) {
      case SortType.cheapFirst:
        list.sort((a, b) => a.price.compareTo(b.price));
        break;
      case SortType.expensiveFirst:
        list.sort((a, b) => b.price.compareTo(a.price));
        break;
      case SortType.popular:
        list.sort((a, b) => (b.reviewCount).compareTo(a.reviewCount));
        break;
    }
    return list;
  }

  void _showSortPicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Сортировка",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              _sortOption(context, "Сначала дешевле", SortType.cheapFirst),
              _sortOption(context, "Сначала дороже", SortType.expensiveFirst),
              _sortOption(context, "По популярности", SortType.popular),
            ],
          ),
        );
      },
    );
  }

  Widget _sortOption(BuildContext context, String title, SortType type) {
    return ListTile(
      title: Text(title),
      trailing: _currentSort == type
          ? const Icon(Icons.check, color: Color(0xFF2E6FF2))
          : null,
      onTap: () {
        setState(() => _currentSort = type);
        Navigator.pop(context);
      },
    );
  }

  Widget _buildCompatibilityBadge(Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: color.withOpacity(0.07),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: color, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              "Для ${widget.compatibleWith}",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color brandBlue = Color(0xFF2E6FF2);
    final products = _sortedProducts;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          widget.categoryName,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        actions: [
          IconButton(
            onPressed: products.isEmpty ? null : _showSortPicker,
            icon: const Icon(Icons.swap_vert),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.tune),
          ),
        ],
      ),
      body: products.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    widget.compatibleWith != null
                        ? 'Нет подходящих запчастей для ${widget.compatibleWith}'
                        : 'Товары скоро появятся',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                if (widget.compatibleWith != null)
                  _buildCompatibilityBadge(brandBlue),
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(8),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 8,
                      childAspectRatio: 0.45,
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      return ProductCardItem(product: products[index]);
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
