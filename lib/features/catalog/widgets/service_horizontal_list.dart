import 'package:flutter/material.dart';

import 'service_item.dart';

class ServiceHorizontalList extends StatelessWidget {
  final void Function(BuildContext context, String serviceName)? onServiceTap;

  const ServiceHorizontalList({super.key, this.onServiceTap});

  @override
  Widget build(BuildContext context) {
    final services = [
      {'title': 'СТО', 'icon': Icons.build_circle_rounded, 'color': Colors.blue},
      {'title': 'Мойка', 'icon': Icons.local_car_wash_rounded, 'color': Colors.cyan},
      {'title': 'Шины', 'icon': Icons.tire_repair_rounded, 'color': Colors.orange},
      {'title': 'Запчасти', 'icon': Icons.settings_suggest_rounded, 'color': Colors.red},
      {'title': 'Масла', 'icon': Icons.oil_barrel_rounded, 'color': Colors.amber},
      {'title': 'Эвакуатор', 'icon': Icons.car_repair_rounded, 'color': Colors.indigo},
      {'title': 'Страховка', 'icon': Icons.security_rounded, 'color': Colors.green},
      {'title': 'Помощь', 'icon': Icons.support_agent_rounded, 'color': Colors.purple},
    ];

    return SizedBox(
      height: 110,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemCount: 8,
        itemBuilder: (context, index) {
          final item = GestureDetector(
            onTap: onServiceTap != null
                ? () => onServiceTap!(context, services[index]['title'] as String)
                : null,
            child: ServiceItem(
              title: services[index]['title'] as String,
              icon: services[index]['icon'] as IconData,
              color: services[index]['color'] as Color,
            ),
          );
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: item,
          );
        },
      ),
    );
  }
}
