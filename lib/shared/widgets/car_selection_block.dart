import 'package:flutter/material.dart';

class CarSelectionBlock extends StatelessWidget {
  final String? selectedCar;
  final VoidCallback onAddTap;

  const CarSelectionBlock({
    super.key,
    this.selectedCar,
    required this.onAddTap,
  });

  @override
  Widget build(BuildContext context) {
    const Color brandBlue = Color(0xFF2E6FF2);

    return Container(
      margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: selectedCar != null ? Colors.white : brandBlue.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: selectedCar != null ? brandBlue : Colors.transparent,
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.directions_car, color: brandBlue, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  selectedCar ?? "Ваш автомобиль",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  selectedCar != null
                      ? "Запчасти подходят"
                      : "Добавьте для точного подбора",
                  style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: onAddTap,
            child: Text(selectedCar != null ? "Изменить" : "Добавить"),
          ),
        ],
      ),
    );
  }
}
