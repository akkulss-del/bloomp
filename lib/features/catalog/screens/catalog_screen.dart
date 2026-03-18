import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/providers/garage_provider.dart';
import '../auto_categories.dart';
import '../widgets/auto_banner_slider.dart';
import '../widgets/car_selection_sheet.dart';
import '../../home/widgets/category_card.dart';

class CatalogScreen extends StatelessWidget {
  const CatalogScreen({super.key});

  void _showCarPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const CarSelectionSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vehicle = context.watch<GarageProvider>().selectedVehicle;
    final _selectedCarText = vehicle != null
        ? '${vehicle.brand} ${vehicle.model}, ${vehicle.year}'
        : null;
    final products = List.generate(20, (index) => {
      "n": "Масло моторное 5W-40 4л ${index + 1}",
      "p": "${18500 + index * 100} ₸",
      "o": "${22000 + index * 100} ₸",
      "d": "-${15 + (index % 10)}%"
    });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // 1. БАННЕРЫ (Прижаты вплотную к AppBar)
          const SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.zero,
              child: AutoBannerSlider(),
            ),
          ),

          // 2. МОЙ АВТОМОБИЛЬ (под баннером)
          SliverToBoxAdapter(
            child: GestureDetector(
              onTap: () => _showCarPicker(context),
              child: Container(
                margin: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.withOpacity(0.2), width: 1.5),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.directions_car_filled, color: Colors.blue, size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Ваш автомобиль",
                            style: TextStyle(fontSize: 10, color: Colors.grey),
                          ),
                          Text(
                            _selectedCarText ?? "Марка, модель, год",
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.edit_note, color: Colors.blue, size: 20),
                  ],
                ),
              ),
            ),
          ),

          // 3. СЕТКА КАТЕГОРИЙ
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 5,
                crossAxisSpacing: 5,
                childAspectRatio: 1.0,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) => CategoryCard(index: index),
                childCount: autoCategories.length,
              ),
            ),
          ),

          // 4. ЗАГОЛОВОК ПЕРЕД ТОВАРАМИ
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Text(
                "Рекомендуем вам",
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
              ),
            ),
          ),

          // 5. СЕТКА ТОВАРОВ
          _buildProductGrid(products),

          // Отступ снизу
          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }

  Widget _buildProductGrid(List<Map<String, String>> products) {
    return SliverMainAxisGroup(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.zero,
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 1,
              crossAxisSpacing: 1,
              mainAxisExtent: 600,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final p = products[index % products.length];
                return _buildProductCard(
                  name: p['n']!,
                  price: p['p']!,
                  oldPrice: p['o']!,
                  discount: p['d']!,
                  rating: 4.8,
                  reviews: 150,
                  index: index,
                );
              },
              childCount: 20,
            ),
          ),
        ),
        // ЭТОТ БЛОК СКРУГЛЯЕТ КОНЕЦ СЕТКИ
        SliverToBoxAdapter(
          child: Container(
            height: 30,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(25)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProductCard({
    required String name,
    required String price,
    required String oldPrice,
    required String discount,
    required double rating,
    required int reviews,
    int index = 0,
  }) {
    const Color wbPink = Color(0xFFF91155);

    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. ОГРОМНОЕ ФОТО (Низ НЕ закруглен)
          AspectRatio(
            aspectRatio: 0.65,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(15), // Только верх скруглен
                    bottom: Radius.zero,       // НИЗ ПРЯМОЙ
                  ),
                  child: Image.network(
                    'https://picsum.photos/600/1000?random=$index',
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),

                // ИКОНКА ИЗБРАННОГО
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.favorite_border_rounded, color: wbPink, size: 18),
                  ),
                ),
              ],
            ),
          ),

          // 2. ИНФОРМАЦИЯ
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // ЦЕНЫ
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(price, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
                      const SizedBox(width: 8),
                      if (oldPrice.isNotEmpty)
                        Text(oldPrice, style: const TextStyle(fontSize: 14, color: Colors.grey, decoration: TextDecoration.lineThrough)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  // РЕЙТИНГ
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.orange, size: 14),
                      Text(" $rating", style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                      Text(" ($reviews)", style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  // НАЗВАНИЕ
                  Text(name, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 12),

                  // КНОПКА КОРЗИНЫ
                  _buildAddToCartButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddToCartButton() {
    return SizedBox(
      width: double.infinity,
      height: 38,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFF91155),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 0,
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_cart_outlined, size: 16, color: Colors.white),
            SizedBox(width: 8),
            Text("В корзину", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Container(
        height: 40,
        decoration: BoxDecoration(
          color: const Color(0xFFF2F3F5),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const TextField(
          decoration: InputDecoration(
            hintText: 'Искать в Bloomp',
            prefixIcon: Icon(Icons.search, color: Colors.grey, size: 20),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: 8),
          ),
        ),
      ),
    );
  }
}
