import 'package:flutter/material.dart';

/// Основные категории запчастей с иконками и описаниями.
/// image — путь к PNG в assets (например, assets/png/engine_icon.png).
/// icon — fallback IconData, если изображение недоступно.
const List<Map<String, dynamic>> partCategories = [
  {
    'title': 'Двигатель',
    'image': 'assets/png/engine_icon.png',
    'icon': Icons.engineering_outlined,
    'description': 'Поршни, ГРМ, прокладки',
  },
  {
    'title': 'Ходовая',
    'image': 'assets/png/suspension.png',
    'icon': Icons.settings_input_component,
    'description': 'Амортизаторы и рычаги',
  },
  {
    'title': 'Тормоза',
    'image': 'assets/png/brakes.png',
    'icon': Icons.stop_circle_outlined,
    'description': 'Диски и колодки (самый частый запрос)',
  },
  {
    'title': 'Фильтры',
    'image': 'assets/png/filters.png',
    'icon': Icons.filter_alt_outlined,
    'description': 'Масляный, воздушный, салонный',
  },
  {
    'title': 'Электрика',
    'image': 'assets/png/spark_plug.png',
    'icon': Icons.electrical_services_outlined,
    'description': 'Свечи зажигания, катушки',
  },
  {
    'title': 'Кузов',
    'image': 'assets/png/body_parts.png',
    'icon': Icons.directions_car_outlined,
    'description': 'Бамперы, капоты, зеркала',
  },
];
