import 'package:flutter/material.dart';
import '../../shared/models/cart_item.dart';
import '../../shared/models/product.dart';

class CartProvider with ChangeNotifier {
  final Map<String, CartItem> _items = {};

  List<CartItem> get items => _items.values.toList();
  int get itemCount => _items.values.fold(0, (sum, item) => sum + item.quantity);
  double get totalAmount => _items.values.fold(0.0, (sum, item) => sum + (item.price * item.quantity));
  double get totalPrice => totalAmount;
  double get totalSaved => _items.values.fold(0.0, (sum, item) => sum + (item.savedAmount * item.quantity));

  void addToCart(CartItem item) {
    if (_items.containsKey(item.id)) {
      _items[item.id]!.quantity += item.quantity;
    } else {
      _items[item.id] = item;
    }
    notifyListeners();
  }

  void addItem(Product product, {int quantity = 1}) => addItemFromProduct(product, quantity: quantity);

  void addItemFromProduct(Product product, {int quantity = 1}) {
    addToCart(CartItem(
      id: product.id,
      name: product.name,
      price: product.price,
      oldPrice: product.oldPrice,
      quantity: quantity,
      imageUrl: product.imageUrl,
    ));
  }

  void increment(String id) {
    if (_items.containsKey(id)) {
      _items[id]!.quantity++;
      notifyListeners();
    }
  }

  void decrement(String id) {
    if (_items.containsKey(id)) {
      if (_items[id]!.quantity > 1) {
        _items[id]!.quantity--;
      } else {
        _items.remove(id);
      }
      notifyListeners();
    }
  }

  void removeItem(String id) {
    _items.remove(id);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }

  bool isInCart(String productId) => _items.containsKey(productId);
}
