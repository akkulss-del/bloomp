import 'dart:async';
import 'package:flutter/material.dart';

class AutoScrollingBanner extends StatefulWidget {
  const AutoScrollingBanner({super.key});

  @override
  State<AutoScrollingBanner> createState() => _AutoScrollingBannerState();
}

class _AutoScrollingBannerState extends State<AutoScrollingBanner> {
  late final PageController _pageController;
  Timer? _timer;
  int _currentPage = 1000;

  // Список из 10 баннеров (можно заменить на Image.network)
  final List<Color> _colors = [
    Colors.blue, Colors.red, Colors.green, Colors.orange, Colors.purple,
    Colors.teal, Colors.pink, Colors.amber, Colors.cyan, Colors.indigo,
  ];

  @override
  void initState() {
    super.initState();
    // viewportFraction: 0.9 делает баннеры "раздельными" (видны соседние)
    _pageController = PageController(initialPage: _currentPage, viewportFraction: 0.9);
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_pageController.hasClients) {
        _currentPage++;
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(top: 0),
      child: SizedBox(
        height: 150,
        child: Listener(
          onPointerDown: (_) => _timer?.cancel(),
          onPointerUp: (_) => _startTimer(),
          child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) => _currentPage = index,
              itemCount: 10000,
              itemBuilder: (context, index) {
                final color = _colors[index % _colors.length];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Container(
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        )
                      ],
                    ),
                    child: Center(
                      child: Text(
                        "АКЦИЯ ${(index % _colors.length) + 1}",
                        style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                );
              },
          ),
        ),
      ),
    );
  }
}
