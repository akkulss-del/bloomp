class Product {
  final String id;
  final String title;
  final String description;
  final double price;
  final double? oldPrice;
  final String image;
  final String category;
  final double rating;
  final int reviews;
  final bool inStock;
  final String brand;
  final List<String> images;
  
  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    this.oldPrice,
    required this.image,
    required this.category,
    required this.rating,
    required this.reviews,
    this.inStock = true,
    required this.brand,
    List<String>? images,
  }) : images = images ?? [image];
  
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'].toString(),
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      oldPrice: json['old_price'] != null ? (json['old_price'] as num).toDouble() : null,
      image: json['image'] ?? '',
      category: json['category'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      reviews: json['reviews'] ?? 0,
      inStock: json['in_stock'] ?? true,
      brand: json['brand'] ?? '',
      images: json['images'] != null 
          ? List<String>.from(json['images'])
          : [json['image'] ?? ''],
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'old_price': oldPrice,
      'image': image,
      'category': category,
      'rating': rating,
      'reviews': reviews,
      'in_stock': inStock,
      'brand': brand,
      'images': images,
    };
  }
  
  int? get discountPercent {
    if (oldPrice == null || oldPrice! <= price) return null;
    return (((oldPrice! - price) / oldPrice!) * 100).round();
  }
}