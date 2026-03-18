import 'package:flutter/material.dart';
import '../../../core/theme/wb_theme.dart';

class WbAiSearchBar extends StatelessWidget {
  final VoidCallback? onTap;
  final VoidCallback? onAiTap;
  final VoidCallback? onMicTap;
  final VoidCallback? onCameraTap;

  const WbAiSearchBar({
    super.key,
    this.onTap,
    this.onAiTap,
    this.onMicTap,
    this.onCameraTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        gradient: WBTheme.wbGradient,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            // Иконка поиска
            Icon(
              Icons.search,
              color: WBTheme.wbPurple,
              size: 24,
            ),
            const SizedBox(width: 12),

            // Текст "Поиск"
            Expanded(
              child: InkWell(
                onTap: onTap ?? () => _showSnackBar(context, 'Поиск скоро будет доступен!'),
                child: Text(
                  'Поиск',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),

            // Кнопка AI
            GestureDetector(
              onTap: onAiTap ?? () => _showSnackBar(context, 'AI помощник скоро!'),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: const Text(
                  'Ai',
                  style: TextStyle(
                    color: WBTheme.wbPurple,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),

            // Иконка микрофона
            GestureDetector(
              onTap: onMicTap ?? () => _showSnackBar(context, 'Голосовой поиск скоро!'),
              child: Icon(
                Icons.mic_none,
                color: WBTheme.wbPurple,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),

            // Иконка камеры
            GestureDetector(
              onTap: onCameraTap ?? () => _showSnackBar(context, 'AI поиск по фото скоро!'),
              child: Icon(
                Icons.camera_alt_outlined,
                color: WBTheme.wbPurple,
                size: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: WBTheme.wbPurple,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 1),
      ),
    );
  }
}