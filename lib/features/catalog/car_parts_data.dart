import 'package:flutter/material.dart';

/// Подробный список запчастей с изображениями (21 категория в 3 ряда).
const List<Map<String, dynamic>> detailedParts = [
  {'title': 'Фильтры', 'image': 'assets/parts/filter.png', 'icon': Icons.filter_alt_outlined, 'id': 'filters'},
  {'title': 'Свечи', 'image': 'assets/parts/spark_plug.png', 'icon': Icons.wb_incandescent_outlined, 'id': 'spark_plugs'},
  {'title': 'Масла', 'image': 'assets/parts/oil_can.png', 'icon': Icons.oil_barrel_outlined, 'id': 'oils'},
  {'title': 'Тормоза', 'image': 'assets/parts/brake_disc.png', 'icon': Icons.stop_circle_outlined, 'id': 'brakes'},
  {'title': 'Колодки', 'image': 'assets/parts/pads.png', 'icon': Icons.square_outlined, 'id': 'pads'},
  {'title': 'Ремни ГРМ', 'image': 'assets/parts/belt.png', 'icon': Icons.linear_scale, 'id': 'belts'},
  {'title': 'Антифриз', 'image': 'assets/parts/coolant.png', 'icon': Icons.water_drop_outlined, 'id': 'liquids'},
  {'title': 'Подвеска', 'image': 'assets/parts/shock.png', 'icon': Icons.settings_input_component, 'id': 'suspension'},
  {'title': 'Амортизаторы', 'image': 'assets/parts/strut.png', 'icon': Icons.settings_input_component, 'id': 'struts'},
  {'title': 'Рычаги', 'image': 'assets/parts/arm.png', 'icon': Icons.swap_horiz, 'id': 'arms'},
  {'title': 'Двигатель', 'image': 'assets/parts/engine.png', 'icon': Icons.engineering_outlined, 'id': 'engine'},
  {'title': 'Прокладки', 'image': 'assets/parts/gasket.png', 'icon': Icons.circle_outlined, 'id': 'gaskets'},
  {'title': 'Турбины', 'image': 'assets/parts/turbo.png', 'icon': Icons.speed, 'id': 'turbo'},
  {'title': 'Сцепление', 'image': 'assets/parts/clutch.png', 'icon': Icons.settings, 'id': 'clutch'},
  {'title': 'Кузовщина', 'image': 'assets/parts/hood.png', 'icon': Icons.directions_car_outlined, 'id': 'body'},
  {'title': 'Фары/Свет', 'image': 'assets/parts/headlight.png', 'icon': Icons.lightbulb_outline, 'id': 'lights'},
  {'title': 'Зеркала', 'image': 'assets/parts/mirror.png', 'icon': Icons.camera_front_outlined, 'id': 'mirrors'},
  {'title': 'Стекла', 'image': 'assets/parts/glass.png', 'icon': Icons.window_outlined, 'id': 'glass'},
  {'title': 'Аккум', 'image': 'assets/parts/battery.png', 'icon': Icons.battery_charging_full, 'id': 'battery'},
  {'title': 'Датчики', 'image': 'assets/parts/sensor.png', 'icon': Icons.sensors, 'id': 'sensors'},
  {'title': 'Охлаждение', 'image': 'assets/parts/radiator.png', 'icon': Icons.ac_unit, 'id': 'cooling'},
];

/// Запчасти, специфичные для марки/модели авто.
/// Ключ: "Brand_Model" (например, Toyota_Camry, Geely_Atlas).
/// 'default' — общий список, когда авто не выбрано.
Map<String, List<Map<String, dynamic>>> carSpecificParts = {
  'Toyota_Camry': [
    {'title': 'Фильтр 2.5', 'icon': Icons.oil_barrel, 'id': 't_oil_1'},
    {'title': 'Колодки V70', 'icon': Icons.stop_circle, 'id': 't_brake_1'},
    {'title': 'Свечи Denso', 'icon': Icons.wb_incandescent_outlined, 'id': 't_spark_1'},
    {'title': 'Ремень ГРМ', 'icon': Icons.linear_scale, 'id': 't_belt_1'},
    {'title': 'Фильтр салона', 'icon': Icons.filter_alt_outlined, 'id': 't_filter_1'},
    {'title': 'Масло 5W-30', 'icon': Icons.opacity, 'id': 't_oil_2'},
    {'title': 'Тормозная жидкость', 'icon': Icons.water_drop_outlined, 'id': 't_brake_2'},
    {'title': 'Амортизаторы', 'icon': Icons.settings_input_component, 'id': 't_susp_1'},
    {'title': 'Стеклоомыватель', 'icon': Icons.water_drop, 'id': 't_washer_1'},
    {'title': 'Аккумулятор', 'icon': Icons.battery_charging_full, 'id': 't_bat_1'},
  ],
  'Toyota': [
    {'title': 'Свечи Denso', 'icon': Icons.wb_incandescent_outlined, 'id': 'toyota_spark'},
    {'title': 'Масло 0W-20', 'icon': Icons.oil_barrel, 'id': 'toyota_oil'},
    {'title': 'Фильтр Camry', 'icon': Icons.filter_alt_outlined, 'id': 'toyota_filter'},
    {'title': 'Колодки Toyota', 'icon': Icons.stop_circle, 'id': 'toyota_brake'},
    {'title': 'Ремень ГРМ', 'icon': Icons.linear_scale, 'id': 'toyota_belt'},
    {'title': 'Фильтр салона', 'icon': Icons.air_outlined, 'id': 'toyota_cabin'},
    {'title': 'Масло 5W-30', 'icon': Icons.opacity, 'id': 'toyota_oil2'},
    {'title': 'Тормозная жидкость', 'icon': Icons.water_drop_outlined, 'id': 'toyota_brake2'},
    {'title': 'Амортизаторы', 'icon': Icons.settings_input_component, 'id': 'toyota_susp'},
    {'title': 'Аккумулятор', 'icon': Icons.battery_charging_full, 'id': 'toyota_bat'},
  ],
  'Geely_Atlas': [
    {'title': 'Фильтр Geely', 'icon': Icons.oil_barrel, 'id': 'g_oil_1'},
    {'title': 'Свечи Torch', 'icon': Icons.wb_incandescent_outlined, 'id': 'g_spark_1'},
    {'title': 'Колодки передние', 'icon': Icons.stop_circle, 'id': 'g_brake_1'},
    {'title': 'Масло 5W-40', 'icon': Icons.opacity, 'id': 'g_oil_2'},
    {'title': 'Фильтр воздушный', 'icon': Icons.filter_alt_outlined, 'id': 'g_filter_1'},
    {'title': 'Ремни', 'icon': Icons.linear_scale, 'id': 'g_belt_1'},
    {'title': 'Подвеска', 'icon': Icons.settings_input_component, 'id': 'g_susp_1'},
    {'title': 'Датчик кислорода', 'icon': Icons.sensors, 'id': 'g_sensor_1'},
  ],
  'default': detailedParts,
};

/// Возвращает запчасти для авто. Ключ: "Brand_Model" (пробелы заменяются на _).
List<Map<String, dynamic>> getCarParts(String? brand, String? model) {
  if (brand == null || brand.isEmpty) return carSpecificParts['default']!;
  final modelPart = (model ?? '').split(' ').first;
  final key = '${brand}_$modelPart';
  return carSpecificParts[key] ??
      carSpecificParts[brand] ??
      carSpecificParts['default']!;
}
