class CartItem {
  final String id;
  final String name;
  final double price;
  final double? oldPrice;
  int quantity;
  final String? imageUrl;
  final String? storeName;
  final String? storeAddress;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    this.oldPrice,
    this.quantity = 1,
    this.imageUrl,
    this.storeName,
    this.storeAddress,
  });

  double get totalPrice => price * quantity;
  double get savedAmount => (oldPrice ?? price) - price;
}
