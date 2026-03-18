import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../car_data.dart';

/// Открывает bottom sheet с ToyotaModelPicker.
void showToyotaModelPicker(
  BuildContext context, {
  required String brandName,
  required List<String> models,
  void Function(String model)? onModelSelected,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => ToyotaModelPicker(
      brandName: brandName,
      models: models,
      onModelSelected: onModelSelected,
    ),
  );
}

/// Пикер моделей с точной прокруткой к секциям через ScrollablePositionedList.
class ToyotaModelPicker extends StatefulWidget {
  final String brandName;
  final List<String> models;
  final void Function(String model)? onModelSelected;

  const ToyotaModelPicker({
    super.key,
    this.brandName = 'Toyota',
    required this.models,
    this.onModelSelected,
  });

  @override
  State<ToyotaModelPicker> createState() => _ToyotaModelPickerState();
}

class _ToyotaModelPickerState extends State<ToyotaModelPicker> {
  final ItemScrollController _itemScrollController = ItemScrollController();
  final ItemPositionsListener _itemPositionsListener = ItemPositionsListener.create();

  late List<String> _sortedModels;
  late List<String> _alphabet;

  @override
  void initState() {
    super.initState();
    _sortedModels = List.from(widget.models)
      ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
    _alphabet = getAlphabet(_sortedModels);
  }

  void _scrollToSection(String letter) {
    final index = _sortedModels.indexWhere((m) => getGroup(m) == letter);
    if (index != -1) {
      _itemScrollController.scrollTo(
        index: index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  void _onModelTap(String model) {
    if (widget.onModelSelected != null) {
      widget.onModelSelected!(model);
    } else {
      Navigator.pop(context, model);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Stack(
        children: [
          Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Text(
                'Модели ${widget.brandName}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              Expanded(
                child: ScrollablePositionedList.builder(
                  itemCount: _sortedModels.length,
                  itemScrollController: _itemScrollController,
                  itemPositionsListener: _itemPositionsListener,
                  padding: const EdgeInsets.only(right: 50, bottom: 20),
                  itemBuilder: (context, index) {
                    final model = _sortedModels[index];
                    final group = getGroup(model);
                    final isFirstInGroup = index == 0 ||
                        getGroup(_sortedModels[index - 1]) != group;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (isFirstInGroup)
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                            child: Text(
                              group,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2E6FF2),
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 24),
                          title: Text(model, style: const TextStyle(fontSize: 15)),
                          onTap: () => _onModelTap(model),
                        ),
                        const Divider(height: 1, indent: 24, endIndent: 40),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
          Positioned(
            right: 10,
            top: 100,
            bottom: 40,
            child: Container(
              width: 30,
              decoration: BoxDecoration(
                color: Colors.grey[100]!.withOpacity(0.5),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _alphabet.map((letter) {
                  return GestureDetector(
                    onTap: () => _scrollToSection(letter),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3),
                      child: Text(
                        letter,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2E6FF2),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
