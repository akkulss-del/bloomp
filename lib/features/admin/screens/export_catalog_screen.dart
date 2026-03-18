import 'package:flutter/material.dart';

class ExportCatalogScreen extends StatelessWidget {
  const ExportCatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Экспорт каталога')),
      body: const Center(child: Text('Экспорт каталога')),
    );
  }
}
