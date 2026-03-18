import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../../../shared/models/product.dart';
import '../../../core/providers/cart_provider.dart';
import '../../../core/providers/favorites_provider.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _quantity = 1;
  int _currentImageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final favProvider = Provider.of<FavoritesProvider>(context);
    final isFavorite = favProvider.isFavorite(widget.product.id);
    final isInCart = cartProvider.isInCart(widget.product.id);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : Colors.black,
            ),
            onPressed: () => favProvider.toggleFavorite(widget.product.id),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImageSlider(),
            _buildMainInfo(),
            _buildPromoTimer(),
            _buildQuantitySelector(),
            _buildReviewsSection(),
            _buildSimilarProducts(),
            _buildEndlessRecommendations(),
          ],
        ),
      ),
      bottomNavigationBar: _buildStickyBottomBar(context, cartProvider, isInCart),
    );
  }

  Widget _buildImageSlider() {
    final images = widget.product.images.isNotEmpty
        ? widget.product.images
        : ['https://picsum.photos/400/400'];
    return Stack(
      children: [
        SizedBox(
          height: 350,
          child: PageView.builder(
            onPageChanged: (i) => setState(() => _currentImageIndex = i),
            itemCount: images.length,
            itemBuilder: (context, index) => CachedNetworkImage(
              imageUrl: images[index],
              fit: BoxFit.cover,
              placeholder: (_, __) => Container(color: Colors.grey[100], child: const Center(child: CircularProgressIndicator())),
              errorWidget: (_, __, ___) => Container(color: Colors.grey[100], child: const Icon(Icons.image, size: 80, color: Colors.grey)),
            ),
          ),
        ),
        Positioned(
          bottom: 16,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(images.length, (i) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentImageIndex == i ? Colors.blue : Colors.grey[300],
              ),
            )),
          ),
        ),
      ],
    );
  }

  Widget _buildMainInfo() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPriceSection(),
          const SizedBox(height: 12),
          Text(
            widget.product.name,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, height: 1.3),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceSection() {
    final p = widget.product;
    final hasDiscount = p.oldPrice != null && p.oldPrice! > p.price;
    final discount = hasDiscount ? ((1 - p.price / p.oldPrice!) * 100).round() : 0;
    return Row(
      children: [
        Text('${p.price.toInt()} ₸', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
        if (hasDiscount) ...[
          const SizedBox(width: 10),
          Text('${p.oldPrice!.toInt()} ₸', style: TextStyle(decoration: TextDecoration.lineThrough, color: Colors.grey[400], fontSize: 16)),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(color: Colors.pink, borderRadius: BorderRadius.circular(4)),
            child: Text('-$discount%', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
          ),
        ],
      ],
    );
  }

  Widget _buildPromoTimer() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.red[50],
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.red[100]!),
        ),
        child: Row(
          children: [
            const Icon(Icons.timer_outlined, color: Colors.red, size: 20),
            const SizedBox(width: 8),
            const Text(
              'Акция закончится через:',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.w500),
            ),
            const Spacer(),
            _buildTimerUnit('03', 'дня'),
          ],
        ),
      ),
    );
  }

  Widget _buildTimerUnit(String value, String label) {
    return Row(
      children: [
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.red)),
      ],
    );
  }

  Widget _buildQuantitySelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          const Text('Количество:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          const SizedBox(width: 20),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove, size: 20),
                  onPressed: _quantity > 1 ? () => setState(() => _quantity--) : null,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text('$_quantity', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
                IconButton(
                  icon: const Icon(Icons.add, size: 20),
                  onPressed: () => setState(() => _quantity++),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsSection() {
    final rating = widget.product.rating;
    final reviewCount = widget.product.reviewCount;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Отзывы', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              TextButton(
                onPressed: () {},
                child: Text('Все ${reviewCount > 0 ? reviewCount : 124}', style: const TextStyle(color: Color(0xFF2E6FF2))),
              ),
            ],
          ),
          Row(
            children: [
              Text('${rating > 0 ? rating : 4.8}', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStarRating((rating > 0 ? rating.round() : 4)),
                  const Text('92% рекомендуют этот товар', style: TextStyle(color: Colors.green, fontSize: 12)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSingleReview('Александр К.', 'Фильтр подошел идеально на Geely Atlas Pro 2022 года. Качество оригинала.'),
        ],
      ),
    );
  }

  Widget _buildStarRating(int count) {
    return Row(
      children: List.generate(5, (i) => Icon(Icons.star, size: 16, color: i < count ? Colors.orange : Colors.grey[300])),
    );
  }

  Widget _buildSingleReview(String name, String text) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(text, style: const TextStyle(fontSize: 13, color: Colors.black87)),
        ],
      ),
    );
  }

  Widget _buildSimilarProducts() {
    const similarItems = [
      {'title': 'Фильтр Bosch', 'price': '4 500 ₸', 'img': Icons.settings_input_component},
      {'title': 'Фильтр Mann', 'price': '5 200 ₸', 'img': Icons.settings_suggest},
      {'title': 'Уплотнитель', 'price': '800 ₸', 'img': Icons.adjust},
      {'title': 'Пробка сливная', 'price': '1 200 ₸', 'img': Icons.build},
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Text(
              'Похожие товары',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 180,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 4),
              itemCount: similarItems.length,
              itemBuilder: (context, index) => _buildSimilarProductCard(similarItems[index]),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSimilarProductCard(Map<String, dynamic> item) {
    return Container(
      width: 130,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              ),
              child: Center(
                child: Icon(item['img'] as IconData, size: 30, color: Colors.blueGrey[300]),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['price'] as String,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 2),
                Text(
                  item['title'] as String,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 11, color: Colors.black87),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEndlessRecommendations() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 15),
          child: Text(
            'Возможно, вам подойдет',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 8),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 0.6,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
          ),
          itemCount: 15,
          itemBuilder: (context, index) => _buildCompactRecommendationCard(context, index),
        ),
        const SizedBox(height: 30),
        const Center(child: CircularProgressIndicator(color: Color(0xFF2E6FF2), strokeWidth: 2)),
        const SizedBox(height: 100),
      ],
    );
  }

  Widget _buildCompactRecommendationCard(BuildContext context, int index) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(
              product: Product(
                id: 'rec_$index',
                name: 'Колодки тормозные',
                description: '',
                price: 2850,
                category: '',
              ),
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                ),
                child: const Icon(Icons.inventory_2_outlined, size: 24, color: Colors.grey),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '2 850 ₸',
                      style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: Colors.black),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'Колодки тормозные',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 10, height: 1.1, color: Colors.black87),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.orange, size: 10),
                        Text(' 4.7', style: TextStyle(fontSize: 9, color: Colors.grey[600])),
                      ],
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

  Widget _buildAddToCartButton({
    required bool isInCart,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 40,
      child: ElevatedButton(
        onPressed: isInCart ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFF91155),
          foregroundColor: Colors.white,
          disabledBackgroundColor: Colors.grey[300],
          disabledForegroundColor: Colors.grey[600],
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_cart_outlined,
              size: 18,
              color: isInCart ? Colors.grey[600] : Colors.white,
            ),
            const SizedBox(width: 8),
            Text(
              isInCart ? 'В КОРЗИНЕ' : 'В КОРЗИНУ',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }


  }


  }


  }


  }


  }


  }


  }


  }


  }


  }


  }


  }

  Widget _buildStickyBottomBar(
      BuildContext context, CartProvider cartProvider, bool isInCart) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFF2E6FF2)),
                minimumSize: const Size(0, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {},
              child: const Text('Купить сейчас', style: TextStyle(color: Color(0xFF2E6FF2), fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildAddToCartButton(
              isInCart: isInCart,
              onPressed: () {
                cartProvider.addItemFromProduct(widget.product, quantity: _quantity);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Добавлено в корзину'),
                    behavior: SnackBarBehavior.floating,
                    duration: Duration(seconds: 1),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
