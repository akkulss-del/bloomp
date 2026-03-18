/// Статус объявления товара
enum ProductStatus { active, sold, hidden, pending }

class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final double? oldPrice;
  final String? imageUrl;
  final List<String>? imageUrls;
  final String category;
  final String? brand;
  final bool inStock;
  final double rating;
  final int reviewCount;

  // Расширенные поля
  final String? subcategory;
  final String? partNumber;
  final String? condition;
  final int? stock;
  final bool? isAvailable;
  final String? sellerName;
  final String? location;
  final bool? hasDelivery;
  final double? deliveryPrice;
  final int? soldCount;
  final List<String>? compatibleBrands;
  final List<String>? compatibleModels;
  final List<int>? compatibleYears;
  final List<String>? compatibleCars;
  final List<String>? imagesList; // хранит images из конструктора
  final String? mainImage;
  final ProductStatus? status;
  final bool? isFeatured;
  final bool? isNegotiable;
  final List<String>? tags;
  final DateTime? createdAt;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.oldPrice,
    this.imageUrl,
    this.imageUrls,
    required this.category,
    this.brand,
    this.inStock = true,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.subcategory,
    this.partNumber,
    this.condition,
    this.stock,
    this.isAvailable,
    this.sellerName,
    this.location,
    this.hasDelivery,
    this.deliveryPrice,
    this.soldCount,
    this.compatibleBrands,
    this.compatibleModels,
    this.compatibleYears,
    this.compatibleCars,
    this.imagesList,
    this.mainImage,
    this.status,
    this.isFeatured,
    this.isNegotiable,
    this.tags,
    this.createdAt,
  });

  String get title => name;
  String get image => mainImage ?? imageUrl ?? (imagesList?.isNotEmpty == true ? imagesList!.first : (imageUrls?.isNotEmpty == true ? imageUrls!.first : ''));
  int get reviews => reviewCount;
  List<String> get images => imagesList ?? imageUrls ?? (mainImage != null ? [mainImage!] : (imageUrl != null ? [imageUrl!] : []));

  int? get discountPercent {
    if (oldPrice == null || oldPrice! <= price) return null;
    return (((oldPrice! - price) / oldPrice!) * 100).round();
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    List<String>? imageUrls;
    if (json['image_urls'] != null) {
      imageUrls = (json['image_urls'] as List).map((e) => e.toString()).toList();
    }
    if (json['images'] != null) {
      imageUrls ??= (json['images'] as List).map((e) => e.toString()).toList();
    }
    return Product(
      id: json['id'].toString(),
      name: json['name'] ?? json['title'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      oldPrice: json['old_price'] != null ? (json['old_price'] as num).toDouble() : null,
      imageUrl: json['image_url'] ?? json['image'] ?? json['main_image'],
      imageUrls: imageUrls,
      category: json['category'] ?? '',
      brand: json['brand'],
      inStock: json['in_stock'] ?? json['is_available'] ?? true,
      rating: (json['rating'] ?? 0).toDouble(),
      reviewCount: json['review_count'] ?? json['reviews'] ?? 0,
      subcategory: json['subcategory'],
      partNumber: json['part_number'],
      condition: json['condition'],
      stock: json['stock'],
      isAvailable: json['is_available'],
      sellerName: json['seller_name'],
      location: json['location'],
      hasDelivery: json['has_delivery'],
      deliveryPrice: json['delivery_price'] != null ? (json['delivery_price'] as num).toDouble() : null,
      soldCount: json['sold_count'],
      compatibleBrands: json['compatible_brands'] != null ? (json['compatible_brands'] as List).map((e) => e.toString()).toList() : null,
      compatibleModels: json['compatible_models'] != null ? (json['compatible_models'] as List).map((e) => e.toString()).toList() : null,
      compatibleYears: json['compatible_years'] != null ? (json['compatible_years'] as List).map((e) => (e as num).toInt()).toList() : null,
      compatibleCars: json['compatible_cars'] != null ? (json['compatible_cars'] as List).map((e) => e.toString()).toList() : null,
      imagesList: json['images'] != null ? (json['images'] as List).map((e) => e.toString()).toList() : null,
      mainImage: json['main_image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id, 'name': name, 'description': description, 'price': price,
      'old_price': oldPrice, 'image_url': imageUrl ?? mainImage, 'image_urls': imageUrls ?? imagesList,
      'category': category, 'brand': brand, 'in_stock': inStock,
      'rating': rating, 'review_count': reviewCount,
    };
  }
}
