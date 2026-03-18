import 'package:flutter/material.dart';

class VoiceSearchScreen extends StatelessWidget {
  const VoiceSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Голосовой поиск'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.mic, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text('Голосовой поиск в разработке', style: TextStyle(color: Colors.grey[600])),
          ],
        ),
      ),
    );
  }
}
