/// Список товаров для каталога (мок-данные).
final List<Map<String, dynamic>> catalogProducts = List.generate(50, (index) {
  const names = [
    "Моторное масло 5W-40 4л",
    "Набор ключей 82 предмета",
    "Освежитель воздуха 'Новая машина'",
    "Свечи зажигания (комплект 4шт)",
    "Жидкость стеклоомывателя -20°C",
    "Щетки стеклоочистителя 600мм",
    "Аккумулятор 60Ah 540A",
    "Компрессор автомобильный 35л/мин",
    "Домкрат ромбический 2т",
    "Набор предохранителей",
    "Тормозные колодки передние",
    "Видеорегистратор 4K Wi-Fi"
  ];
  const prices = [
    "12500",
    "28900",
    "1200",
    "8400",
    "2100",
    "4500",
    "32000",
    "15800"
  ];
  final priceStr = prices[index % prices.length];
  final priceNum = int.parse(priceStr);
  final oldPriceNum = (priceNum * 1.3).toInt();

  String fmt(int n) =>
      n.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]} ');

  return {
    "id": index,
    "name": names[index % names.length],
    "price": "${fmt(priceNum)} ₸",
    "oldPrice": "${fmt(oldPriceNum)} ₸",
    "discount": "-${15 + (index % 20)}%",
    "image": "https://picsum.photos/id/${(index + 10) * 2}/400/400",
  };
});
