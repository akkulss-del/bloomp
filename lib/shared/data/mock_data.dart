import 'package:bloomp/features/catalog/models/product.dart';

class MockData {
  static List<Product> getProducts() {
    return [
      // МАСЛА
      Product(
        id: '1',
        title: 'Mobil 1 ESP Formula 5W-30 4L',
        description:
            'Полностью синтетическое моторное масло премиум-класса для современных двигателей с турбонаддувом',
        price: 12990,
        oldPrice: 18000,
        image:
            'https://images.unsplash.com/photo-1486262715619-67b85e0b08d3?w=400',
        category: 'Масла',
        rating: 4.9,
        reviews: 127,
        brand: 'Mobil',
      ),
      Product(
        id: '2',
        title: 'Castrol EDGE 5W-40 4L',
        description:
            'Моторное масло с технологией Fluid TITANIUM для максимальной защиты двигателя',
        price: 11500,
        oldPrice: 14000,
        image:
            'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=400',
        category: 'Масла',
        rating: 4.8,
        reviews: 98,
        brand: 'Castrol',
      ),
      Product(
        id: '3',
        title: 'Shell Helix Ultra 5W-40 4L',
        description:
            'Синтетическое масло для максимальной защиты и чистоты двигателя',
        price: 13500,
        image:
            'https://images.unsplash.com/photo-1621905251189-08b45d6a269e?w=400',
        category: 'Масла',
        rating: 4.7,
        reviews: 85,
        brand: 'Shell',
      ),
      Product(
        id: '4',
        title: 'Total Quartz 9000 5W-40 5L',
        description: 'Высокоэффективное синтетическое моторное масло',
        price: 14200,
        oldPrice: 16500,
        image:
            'https://images.unsplash.com/photo-1486262715619-67b85e0b08d3?w=400',
        category: 'Масла',
        rating: 4.6,
        reviews: 72,
        brand: 'Total',
      ),

      // ФИЛЬТРЫ
      Product(
        id: '5',
        title: 'Фильтр масляный Toyota 90915-YZZD2',
        description: 'Оригинальный масляный фильтр для автомобилей Toyota',
        price: 2500,
        image:
            'https://images.unsplash.com/photo-1625047509168-a7026f36de04?w=400',
        category: 'Фильтры',
        rating: 4.8,
        reviews: 156,
        brand: 'Toyota',
      ),
      Product(
        id: '6',
        title: 'Фильтр воздушный Mann C 27 003/1',
        description:
            'Воздушный фильтр премиум качества с высокой степенью очистки',
        price: 3200,
        oldPrice: 4000,
        image:
            'https://images.unsplash.com/photo-1619642751034-765dfdf7c58e?w=400',
        category: 'Фильтры',
        rating: 4.9,
        reviews: 203,
        brand: 'Mann',
      ),
      Product(
        id: '7',
        title: 'Фильтр салона Bosch 1987432120',
        description:
            'Салонный фильтр с активированным углем для очистки воздуха',
        price: 2800,
        image:
            'https://images.unsplash.com/photo-1581092918056-0c4c3acd3789?w=400',
        category: 'Фильтры',
        rating: 4.7,
        reviews: 134,
        brand: 'Bosch',
      ),
      Product(
        id: '8',
        title: 'Фильтр топливный Mahle KL 756',
        description: 'Топливный фильтр для дизельных двигателей',
        price: 3500,
        image:
            'https://images.unsplash.com/photo-1625047509168-a7026f36de04?w=400',
        category: 'Фильтры',
        rating: 4.8,
        reviews: 91,
        brand: 'Mahle',
      ),

      // СВЕЧИ
      Product(
        id: '9',
        title: 'Свечи NGK Iridium IX (4 шт)',
        description:
            'Иридиевые свечи зажигания премиум класса с увеличенным ресурсом',
        price: 8500,
        oldPrice: 10000,
        image:
            'https://images.unsplash.com/photo-1563298723-dcfebaa392e3?w=400',
        category: 'Свечи',
        rating: 4.9,
        reviews: 276,
        brand: 'NGK',
      ),
      Product(
        id: '10',
        title: 'Свечи Denso Platinum (4 шт)',
        description:
            'Платиновые свечи увеличенного ресурса для стабильной работы',
        price: 7200,
        image:
            'https://images.unsplash.com/photo-1492144534655-ae79c964c9d7?w=400',
        category: 'Свечи',
        rating: 4.8,
        reviews: 189,
        brand: 'Denso',
      ),
      Product(
        id: '11',
        title: 'Свечи Bosch Super Plus (4 шт)',
        description: 'Медные свечи зажигания с никелевым покрытием',
        price: 4500,
        image:
            'https://images.unsplash.com/photo-1563298723-dcfebaa392e3?w=400',
        category: 'Свечи',
        rating: 4.6,
        reviews: 143,
        brand: 'Bosch',
      ),

      // АККУМУЛЯТОРЫ
      Product(
        id: '12',
        title: 'Аккумулятор Varta Blue Dynamic 60Ah',
        description: 'Надежный аккумулятор для любых погодных условий',
        price: 35000,
        oldPrice: 42000,
        image:
            'https://images.unsplash.com/photo-1593941707882-a5bba14938c7?w=400',
        category: 'Аккумуляторы',
        rating: 4.7,
        reviews: 312,
        brand: 'Varta',
      ),
      Product(
        id: '13',
        title: 'Аккумулятор Bosch S4 74Ah',
        description: 'Увеличенная мощность пуска в любых условиях',
        price: 38500,
        image:
            'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=400',
        category: 'Аккумуляторы',
        rating: 4.8,
        reviews: 245,
        brand: 'Bosch',
      ),
      Product(
        id: '14',
        title: 'Аккумулятор Mutlu 63Ah',
        description:
            'Турецкий аккумулятор с отличным соотношением цена-качество',
        price: 28000,
        image:
            'https://images.unsplash.com/photo-1593941707882-a5bba14938c7?w=400',
        category: 'Аккумуляторы',
        rating: 4.5,
        reviews: 178,
        brand: 'Mutlu',
      ),

      // ШИНЫ
      Product(
        id: '15',
        title: 'Шины Michelin Primacy 4 205/55 R16',
        description: 'Летние шины премиум класса с отличным сцеплением',
        price: 45000,
        oldPrice: 52000,
        image:
            'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=400',
        category: 'Шины',
        rating: 4.9,
        reviews: 423,
        brand: 'Michelin',
      ),
      Product(
        id: '16',
        title: 'Шины Bridgestone Blizzak 215/60 R16',
        description:
            'Зимние шины с отличным сцеплением на льду и снегу',
        price: 48000,
        image:
            'https://images.unsplash.com/photo-1563298723-dcfebaa392e3?w=400',
        category: 'Шины',
        rating: 4.8,
        reviews: 367,
        brand: 'Bridgestone',
      ),
      Product(
        id: '17',
        title: 'Шины Continental ContiEcoContact 195/65 R15',
        description:
            'Экономичные летние шины с низким сопротивлением качению',
        price: 38000,
        oldPrice: 43000,
        image:
            'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=400',
        category: 'Шины',
        rating: 4.7,
        reviews: 289,
        brand: 'Continental',
      ),
      Product(
        id: '18',
        title: 'Шины Nokian Hakkapeliitta R3 225/50 R17',
        description:
            'Зимние нешипованные шины для суровых условий',
        price: 55000,
        image:
            'https://images.unsplash.com/photo-1563298723-dcfebaa392e3?w=400',
        category: 'Шины',
        rating: 4.9,
        reviews: 512,
        brand: 'Nokian',
      ),

      // ТОРМОЗНЫЕ КОЛОДКИ
      Product(
        id: '19',
        title: 'Колодки тормозные Brembo P 30 076',
        description: 'Передние тормозные колодки премиум качества',
        price: 12500,
        image:
            'https://images.unsplash.com/photo-1625047509168-a7026f36de04?w=400',
        category: 'Тормоза',
        rating: 4.8,
        reviews: 156,
        brand: 'Brembo',
      ),
      Product(
        id: '20',
        title: 'Колодки тормозные ATE 13.0460-2751.2',
        description:
            'Надежные тормозные колодки с низким уровнем шума',
        price: 8900,
        oldPrice: 11000,
        image:
            'https://images.unsplash.com/photo-1619642751034-765dfdf7c58e?w=400',
        category: 'Тормоза',
        rating: 4.7,
        reviews: 203,
        brand: 'ATE',
      ),

      // ДОПОЛНИТЕЛЬНЫЕ ТОВАРЫ
      Product(
        id: '21',
        title: 'Антифриз Total Glacelf Auto Supra 5L',
        description: 'Готовый к применению антифриз -40°C',
        price: 4500,
        image:
            'https://images.unsplash.com/photo-1486262715619-67b85e0b08d3?w=400',
        category: 'Жидкости',
        rating: 4.6,
        reviews: 89,
        brand: 'Total',
      ),
      Product(
        id: '22',
        title: 'Жидкость тормозная Castrol React DOT 4 1L',
        description: 'Высококачественная тормозная жидкость',
        price: 2200,
        image:
            'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=400',
        category: 'Жидкости',
        rating: 4.7,
        reviews: 67,
        brand: 'Castrol',
      ),
      Product(
        id: '23',
        title: 'Щетки стеклоочистителя Bosch Aerotwin 650мм',
        description:
            'Бескаркасные дворники с отличным качеством очистки',
        price: 5500,
        oldPrice: 7000,
        image:
            'https://images.unsplash.com/photo-1581092918056-0c4c3acd3789?w=400',
        category: 'Стеклоочистители',
        rating: 4.8,
        reviews: 134,
        brand: 'Bosch',
      ),
      Product(
        id: '24',
        title: 'Лампы Philips H7 X-treme Vision +130%',
        description: 'Галогеновые лампы с увеличенной яркостью',
        price: 3800,
        image:
            'https://images.unsplash.com/photo-1625047509168-a7026f36de04?w=400',
        category: 'Освещение',
        rating: 4.9,
        reviews: 298,
        brand: 'Philips',
      ),
    ];
  }

  static List<String> getCategories() {
    return [
      'Масла',
      'Фильтры',
      'Свечи',
      'Аккумуляторы',
      'Шины',
      'Тормоза',
      'Подвеска',
      'Электрика',
      'Кузов',
      'Салон',
    ];
  }

  static List<Product> searchProducts(String query) {
    final products = getProducts();
    if (query.isEmpty) return products;

    return products.where((p) {
      return p.title.toLowerCase().contains(query.toLowerCase()) ||
          p.category.toLowerCase().contains(query.toLowerCase()) ||
          p.brand.toLowerCase().contains(query.toLowerCase()) ||
          p.description.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  static List<Product> getProductsByCategory(String category) {
    return getProducts().where((p) => p.category == category).toList();
  }

  static Product? getProductById(String id) {
    try {
      return getProducts().firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }
}