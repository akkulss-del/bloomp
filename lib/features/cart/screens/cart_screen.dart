import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/wb_theme.dart';
import '../../../core/providers/cart_provider.dart';
import '../../../shared/models/cart_item.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  int _deliveryType = 0; // 0 - Самовывоз, 1 - Курьер

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      backgroundColor: WBTheme.wbBg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Корзина', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        actions: [
          if (cart.items.isNotEmpty)
            TextButton(
              onPressed: () => _showClearCartDialog(context, cart),
              child: const Text('Очистить', style: TextStyle(color: Colors.grey)),
            ),
        ],
      ),
      body: cart.items.isEmpty
          ? Center(
              child: Text(
                'Корзина пуста',
                style: TextStyle(fontSize: 18, color: Colors.grey[600]),
              ),
            )
          : Column(
              children: [
                _buildDeliveryToggle(),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    children: _buildStoreGroups(cart),
                  ),
                ),
                _buildCheckoutBottomBar(context, cart),
              ],
            ),
    );
  }

  List<Widget> _buildStoreGroups(CartProvider cart) {
    final groups = <String, List<CartItem>>{};
    for (final item in cart.items) {
      final key = item.storeName ?? "Ваши товары";
      groups.putIfAbsent(key, () => []).add(item);
    }
    return groups.entries.map((e) {
      return _buildStoreGroup(
        e.key,
        e.value.first.storeAddress ?? '',
        e.value,
        cart,
      );
    }).toList();
  }

  Widget _buildDeliveryToggle() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Container(
        height: 45,
        decoration: BoxDecoration(
          color: const Color(0xFFF2F3F5),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            _toggleItem('Самовывоз', 0),
            _toggleItem('Курьер', 1),
          ],
        ),
      ),
    );
  }

  Widget _toggleItem(String title, int index) {
    final isActive = _deliveryType == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _deliveryType = index),
        child: Container(
          decoration: BoxDecoration(
            color: isActive ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            boxShadow: isActive ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)] : null,
          ),
          margin: const EdgeInsets.all(4),
          alignment: Alignment.center,
          child: Text(title, style: TextStyle(fontWeight: isActive ? FontWeight.bold : FontWeight.normal)),
        ),
      ),
    );
  }

  Widget _buildStoreGroup(String storeName, String address, List<CartItem> items, CartProvider cart) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(Icons.storefront, size: 20, color: Color(0xFF2E6FF2)),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(storeName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    if (address.isNotEmpty) Text(address, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          ...items.map((item) => _buildCartItem(item, cart)),
        ],
      ),
    );
  }

  Widget _buildCartItem(CartItem item, CartProvider cart) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildItemImage(item),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name, style: const TextStyle(fontWeight: FontWeight.w500)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text('${_formatPrice(item.price)} ₸', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    if (item.oldPrice != null && item.oldPrice! > item.price) ...[
                      const SizedBox(width: 8),
                      Text('${_formatPrice(item.oldPrice!)} ₸', style: const TextStyle(decoration: TextDecoration.lineThrough, color: Colors.grey, fontSize: 12)),
                    ],
                  ],
                ),
              ],
            ),
          ),
          _buildQuantityControl(item, cart),
        ],
      ),
    );
  }

  Widget _buildItemImage(CartItem item) {
    if (item.imageUrl != null && item.imageUrl!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: CachedNetworkImage(
          imageUrl: item.imageUrl!,
          width: 80,
          height: 80,
          fit: BoxFit.cover,
          placeholder: (_, __) => Container(width: 80, height: 80, color: Colors.grey[100], child: const Center(child: CircularProgressIndicator(strokeWidth: 2))),
          errorWidget: (_, __, ___) => Container(width: 80, height: 80, decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.image, color: Colors.grey)),
        ),
      );
    }
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(8)),
      child: const Icon(Icons.image, color: Colors.grey),
    );
  }

  Widget _buildQuantityControl(CartItem item, CartProvider cart) {
    return Column(
      children: [
        IconButton(
          icon: const Icon(Icons.add_circle_outline, color: Color(0xFF2E6FF2)),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          onPressed: () => cart.increment(item.id),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Text('${item.quantity}', style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
        IconButton(
          icon: Icon(Icons.remove_circle_outline, color: item.quantity > 1 ? const Color(0xFF2E6FF2) : Colors.grey),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          onPressed: item.quantity > 1 ? () => cart.decrement(item.id) : null,
        ),
      ],
    );
  }

  Widget _buildCheckoutBottomBar(BuildContext context, CartProvider cart) {
    final saved = cart.totalSaved;
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 10, offset: const Offset(0, -2))],
      ),
      child: Column(
        children: [
          if (saved > 0) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Ваша скидка:', style: TextStyle(color: Colors.pink)),
                Text('-${_formatPrice(saved)} ₸', style: const TextStyle(color: Colors.pink, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 12),
          ],
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Итого:', style: TextStyle(color: Colors.grey, fontSize: 12)),
                  Text('${_formatPrice(cart.totalPrice)} ₸', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
                ],
              ),
              const SizedBox(width: 20),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF91155),
                    minimumSize: const Size(0, 50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () => _showCheckoutDialog(context),
                  child: const Text('К оформлению', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showClearCartDialog(BuildContext context, CartProvider cart) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Очистить корзину?'),
        content: const Text('Все товары будут удалены из корзины'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Отмена')),
          TextButton(
            onPressed: () {
              cart.clear();
              Navigator.pop(ctx);
            },
            child: const Text('Очистить', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showCheckoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Оформление заказа'),
        content: const Text('Функция оформления заказа будет доступна в следующей версии!'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Понятно')),
        ],
      ),
    );
  }

  String _formatPrice(double price) {
    return price.toInt().toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]} ',
    );
  }
}
