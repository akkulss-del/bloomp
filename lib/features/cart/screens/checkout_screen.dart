import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/cart_provider.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('Оформление заказа')),
      body: cart.items.isEmpty
          ? const Center(child: Text('Корзина пуста'))
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text('Итого: ${cart.totalPrice.toStringAsFixed(0)} ₸', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => Navigator.pushReplacementNamed(context, '/order_success'),
                  child: const Text('Подтвердить заказ'),
                ),
              ],
            ),
    );
  }
}
