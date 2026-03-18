import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';

import '../../../shared/models/product.dart';
import '../../../core/providers/cart_provider.dart';
import '../../catalog/screens/product_detail_screen.dart';

class ProductCard extends StatefulWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> with AutomaticKeepAliveClientMixin {
  late PageController _pageController;
  int _currentPage = 0;
  late List<String> _images;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    final mainImage = widget.product.image.isNotEmpty
        ? widget.product.image
        : 'https://picsum.photos/400/400';
    final idNum = int.tryParse(widget.product.id) ?? widget.product.id.hashCode;
    _images = idNum % 2 == 0
        ? [mainImage, 'https://picsum.photos/400/500', 'https://picsum.photos/401/501']
        : [mainImage];
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  String _formatPrice(num value) {
    return value.toInt().toString().replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]} ',
        );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Обязательно для AutomaticKeepAliveClientMixin
    final cartProvider = Provider.of<CartProvider>(context);
    final product = widget.product;

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProductDetailScreen(product: product),
        ),
      ),
      child: Container(
        margin: EdgeInsets.zero,
        color: Colors.white,
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                AspectRatio(
                  aspectRatio: 3 / 4,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    clipBehavior: Clip.antiAlias,
                    child: PageView.builder(
                      controller: _pageController,
                      physics: const ClampingScrollPhysics(),
                      itemCount: _images.length,
                      onPageChanged: (i) => setState(() => _currentPage = i),
                      itemBuilder: (context, index) => CachedNetworkImage(
                        imageUrl: _images[index],
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                        placeholder: (_, __) => Container(
                          color: Colors.grey[100],
                          child: const Center(
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                        errorWidget: (_, __, ___) => Container(
                          color: Colors.grey[100],
                          child: const Icon(
                            Icons.image_not_supported,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: GestureDetector(
                    onTap: () {},
                    child: const _SmallActionIcon(icon: Icons.search),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () {},
                    child: const _SmallActionIcon(icon: Icons.favorite_border),
                  ),
                ),
                if (_images.length > 1)
                  Positioned(
                    bottom: 10,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(_images.length, (index) {
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          width: _currentPage == index ? 6 : 4,
                          height: 4,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _currentPage == index
                                ? Colors.white
                                : Colors.white.withOpacity(0.5),
                          ),
                        );
                      }),
                    ),
                  ),
                Positioned(
                  bottom: -18,
                  right: 6,
                  child: GestureDetector(
                    onTap: () {
                      cartProvider.addItemFromProduct(product);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Товар добавлен в корзину!'),
                          duration: Duration(seconds: 1),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: const Color(0xFFB347FF),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: const Icon(
                        Icons.shopping_cart_outlined,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -8,
                  left: 6,
                  child: Row(
                    children: [
                      if (product.discountPercent != null) ...[
                        _Badge(text: '-${product.discountPercent}%', isOutline: true),
                        const SizedBox(width: 4),
                      ],
                      const _Badge(text: 'ХОРОШАЯ ЦЕНА', isOutline: false),
                    ],
                  ),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(6, 12, 6, 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${_formatPrice(product.price)} ₸',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFFF91155),
                              height: 1,
                            ),
                          ),
                          if (product.oldPrice != null) ...[
                            const SizedBox(width: 4),
                            Text(
                              '${_formatPrice(product.oldPrice!)} ₸',
                              style: TextStyle(
                                fontSize: 10,
                                decoration: TextDecoration.lineThrough,
                                color: Colors.grey[400],
                                height: 1,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 3),
                    if (product.brand != null && product.brand!.isNotEmpty)
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              '${product.brand!} ',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const Icon(Icons.verified, size: 12, color: Colors.blue),
                        ],
                      ),
                    Text(
                      product.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[600],
                        height: 1.1,
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        children: [
                          const Icon(Icons.star, color: Colors.orange, size: 11),
                          Text(
                            ' ${product.rating.toStringAsFixed(1)}',
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '• ${product.reviewCount} оценок',
                            style: TextStyle(fontSize: 10, color: Colors.grey[500]),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SmallActionIcon extends StatelessWidget {
  final IconData icon;

  const _SmallActionIcon({required this.icon});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 16, color: Colors.black54),
      );
}

class _Badge extends StatelessWidget {
  final String text;
  final bool isOutline;

  const _Badge({required this.text, required this.isOutline});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        color: isOutline ? Colors.white : const Color(0xFFF91155),
        borderRadius: BorderRadius.circular(4),
        border: isOutline ? Border.all(color: const Color(0xFFF91155), width: 0.5) : null,
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isOutline ? const Color(0xFFF91155) : Colors.white,
          fontSize: 8,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
