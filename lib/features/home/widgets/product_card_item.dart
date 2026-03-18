import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';

import '../../../shared/models/product.dart';
import '../../../core/providers/cart_provider.dart';
import '../../catalog/screens/product_detail_screen.dart';

/// Карточка товара в стиле Ozon: квадратное фото, скидка, цена, рейтинг, кнопка «В корзину».
/// InkWell даёт ripple при тапе; кнопка добавляет в корзину без перехода.
class ProductCardItem extends StatelessWidget {
  final Product product;

  const ProductCardItem({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    const Color pinkColor = Color(0xFFF91155);
    const Color brandBlue = Color(0xFF2E6FF2);
    final cartProvider = Provider.of<CartProvider>(context);

    final priceStr = _formatPrice(product.price);
    final oldPriceStr = product.oldPrice != null ? _formatPrice(product.oldPrice!) : null;
    final discount = product.discountPercent ?? 0;
    final imageUrl = product.image.isNotEmpty ? product.image : 'https://via.placeholder.com/300';

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(product: product),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF2F3F5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      placeholder: (_, __) => const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      errorWidget: (_, __, ___) => const Icon(
                        Icons.image_not_supported,
                        color: Colors.grey,
                        size: 40,
                      ),
                    ),
                  ),
                  if (discount > 0)
                    Positioned(
                      bottom: 6,
                      left: 6,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                        decoration: BoxDecoration(
                          color: pinkColor,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '-$discount%',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                '$priceStr ₸',
                style: const TextStyle(
                  color: pinkColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                ),
              ),
              if (oldPriceStr != null) ...[
                const SizedBox(width: 4),
                Text(
                  '$oldPriceStr ₸',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 10,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 4),
          SizedBox(
            height: 32,
            child: Text(
              product.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 11,
                height: 1.2,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.star, color: Colors.orange, size: 12),
              Text(
                ' ${product.rating.toStringAsFixed(1)}',
                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 4),
              Text(
                '${product.reviewCount}',
                style: const TextStyle(fontSize: 10, color: Colors.grey),
              ),
            ],
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            height: 32,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: brandBlue,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                cartProvider.addItemFromProduct(product);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Товар добавлен в корзину'),
                    duration: Duration(seconds: 1),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: const Text(
                'В корзину',
                style: TextStyle(color: Colors.white, fontSize: 11),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static String _formatPrice(double p) {
    return p.toInt().toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]} ',
        );
  }
}
