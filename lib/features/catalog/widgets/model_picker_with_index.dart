import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/providers/garage_provider.dart';
import '../../../shared/models/my_vehicle.dart';
import '../car_data.dart';

class ModelPickerWithIndex extends StatefulWidget {
  final String brandName;
  final List<String> models;
  final void Function(String model)? onModelSelected;

  const ModelPickerWithIndex({
    super.key,
    required this.brandName,
    required this.models,
    this.onModelSelected,
  });

  @override
  State<ModelPickerWithIndex> createState() => _ModelPickerWithIndexState();
}

class _ModelPickerWithIndexState extends State<ModelPickerWithIndex> {
  final ScrollController _scrollController = ScrollController();
  static const double _tileHeight = 52.0;
  late List<String> alphabet;

  @override
  void initState() {
    super.initState();
    alphabet = getAlphabet(widget.models);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToLetter(String letter) {
    final sorted = List<String>.from(widget.models)..sort();
    final index = sorted.indexWhere((m) => getGroup(m) == letter);
    if (index != -1) {
      _scrollController.animateTo(
        index * _tileHeight,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _onModelTap(String model) {
    if (widget.onModelSelected != null) {
      widget.onModelSelected!(model);
    } else {
      context.read<GarageProvider>().saveVehicle(
            MyVehicle(brand: widget.brandName, model: model, year: '—'),
          );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final sorted = List<String>.from(widget.models)..sort();

    return Stack(
      children: [
        ListView.builder(
          controller: _scrollController,
          itemCount: sorted.length,
          itemBuilder: (context, index) {
            final model = sorted[index];
            return ListTile(
              dense: true,
              title: Text(
                model,
                style: const TextStyle(fontSize: 14),
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
              onTap: () => _onModelTap(model),
            );
          },
        ),
        Positioned(
          right: 8,
          top: 40,
          bottom: 40,
          child: alphabet.isEmpty
              ? const SizedBox.shrink()
              : Container(
                  width: 25,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: alphabet.map((letter) {
                      return GestureDetector(
                        onTap: () => _scrollToLetter(letter),
                        child: Text(
                          letter,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2E6FF2),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
        ),
      ],
    );
  }
}
