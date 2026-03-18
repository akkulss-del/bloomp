import 'package:flutter/material.dart';
import '../../../core/theme/wb_theme.dart';

class WBSearchBar extends StatelessWidget {
  final VoidCallback? onTap;
  final VoidCallback? onCameraTap;
  final VoidCallback? onVoiceTap;
  final VoidCallback? onAiTap;

  const WBSearchBar({
    super.key,
    this.onTap,
    this.onCameraTap,
    this.onVoiceTap,
    this.onAiTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      height: 52,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F7),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            const SizedBox(width: 16),

            // Иконка поиска (фиолетовая)
            const Icon(
              Icons.search,
              color: WBTheme.wbPurple,
              size: 28,
            ),

            const SizedBox(width: 12),

            // Поиск + AI кнопка
            Expanded(
              child: InkWell(
                onTap: onTap ??
                    () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Поиск скоро будет доступен!'),
                          backgroundColor: WBTheme.wbPurple,
                          behavior: SnackBarBehavior.floating,
                          duration: Duration(seconds: 1),
                        ),
                      );
                    },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Поиск',
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'Автозапчасти за 15 сек',
                      style: TextStyle(
                        color: WBTheme.wbPurple,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // AI кнопка (компактная)
            InkWell(
              onTap: onAiTap ??
                  () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                gradient: WBTheme.wbGradient,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.auto_awesome,
                                color: Colors.white,
                                size: 12,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text('AI помощник скоро!'),
                          ],
                        ),
                        backgroundColor: WBTheme.wbPurple,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  gradient: WBTheme.wbGradient,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.auto_awesome,
                      color: Colors.white,
                      size: 14,
                    ),
                    SizedBox(width: 4),
                    Text(
                      'AI',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(width: 8),

            // Голосовой поиск (фиолетовый)
            InkWell(
              onTap: onVoiceTap ??
                  () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Row(
                          children: [
                            Icon(Icons.mic, color: Colors.white, size: 20),
                            SizedBox(width: 12),
                            Text('Голосовой поиск скоро!'),
                          ],
                        ),
                        backgroundColor: WBTheme.wbPurple,
                        behavior: SnackBarBehavior.floating,
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.all(8),
                child: const Icon(
                  Icons.mic_none,
                  color: WBTheme.wbPurple,
                  size: 28,
                ),
              ),
            ),

            // AI Камера (фиолетовая)
            InkWell(
              onTap: onCameraTap ??
                  () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Row(
                          children: [
                            Icon(Icons.camera_alt, color: Colors.white,
                                size: 20),
                            SizedBox(width: 12),
                            Text('AI поиск по фото скоро!'),
                          ],
                        ),
                        backgroundColor: WBTheme.wbPurple,
                        behavior: SnackBarBehavior.floating,
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.all(8),
                child: const Icon(
                  Icons.camera_alt_outlined,
                  color: WBTheme.wbPurple,
                  size: 28,
                ),
              ),
            ),

            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
}