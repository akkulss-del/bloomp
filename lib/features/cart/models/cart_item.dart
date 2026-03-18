class CartItem {
  final String id;
  final String productId;
  final String title;
  final double price;
  final String image;
  int quantity;
  
  CartItem({
    required this.id,
    required this.productId,
    required this.title,
    required this.price,
    required this.image,
    this.quantity = 1,
  });
  
  double get totalPrice => price * quantity;
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'title': title,
      'price': price,
      'image': image,
      'quantity': quantity,
    };
  }
  
  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      productId: json['product_id'],
      title: json['title'],
      price: (json['price'] as num).toDouble(),
      image: json['image'],
      quantity: json['quantity'] ?? 1,
    );
  }
}