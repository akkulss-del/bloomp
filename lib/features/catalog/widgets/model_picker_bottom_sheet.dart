import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/providers/garage_provider.dart';
import '../../../shared/models/my_vehicle.dart';
import '../car_data.dart';

/// Bottom sheet для выбора модели с поиском, заголовками групп и алфавитным индексом.
void showModelPickerBottomSheet(
  BuildContext context, {
  required String brandName,
  required List<String> models,
  void Function(String model)? onModelSelected,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => _ModelPickerBottomSheet(
      brandName: brandName,
      models: List.from(models),
      onModelSelected: onModelSelected,
    ),
  );
}

class _ModelPickerBottomSheet extends StatefulWidget {
  final String brandName;
  final List<String> models;
  final void Function(String model)? onModelSelected;

  const _ModelPickerBottomSheet({
    required this.brandName,
    required this.models,
    this.onModelSelected,
  });

  @override
  State<_ModelPickerBottomSheet> createState() => _ModelPickerBottomSheetState();
}

class _ModelPickerBottomSheetState extends State<_ModelPickerBottomSheet> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  static const double _headerHeight = 44.0;
  static const double _tileHeight = 56.0;
  late List<_ListRow> _rows;
  late List<String> _alphabet;
  late Map<String, double> _letterOffsets;

  @override
  void initState() {
    super.initState();
    _buildRowsFromModels(widget.models);
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    setState(() => _buildRowsFromModels(widget.models));
  }

  void _buildRowsFromModels(List<String> models) {
    final query = _searchController.text.toLowerCase().trim();
    var filtered = models.where((m) => m.toLowerCase().contains(query)).toList();
    filtered = List.from(filtered)..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));

    final rows = <_ListRow>[];
    double offset = 0;
    final letterOffsets = <String, double>{};

    for (var i = 0; i < filtered.length; i++) {
      final model = filtered[i];
      final group = getGroup(model);
      final showHeader = i == 0 || getGroup(filtered[i - 1]) != group;

      if (showHeader) {
        if (!letterOffsets.containsKey(group)) letterOffsets[group] = offset;
        rows.add(_ListRow(isHeader: true, value: group));
        offset += _headerHeight;
      }
      rows.add(_ListRow(isHeader: false, value: model));
      offset += _tileHeight;
    }

    _rows = rows;
    _alphabet = getAlphabet(filtered);
    _letterOffsets = letterOffsets;
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToLetter(String letter) {
    final offset = _letterOffsets[letter];
    if (offset != null) {
      _scrollController.animateTo(
        offset.clamp(0.0, _scrollController.position.maxScrollExtent),
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
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          _buildHandle(),
          Text(
            "Выберите модель ${widget.brandName}",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          _buildSearchField(),
          Expanded(
            child: Stack(
              children: [
                ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.only(right: 40),
                  itemCount: _rows.length,
                  itemBuilder: (context, index) {
                    final row = _rows[index];
                    if (row.isHeader) {
                      return Container(
                        width: double.infinity,
                        height: _headerHeight,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        alignment: Alignment.centerLeft,
                        color: const Color(0xFFF8F9FB),
                        child: Text(
                          row.value,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2E6FF2),
                            fontSize: 14,
                          ),
                        ),
                      );
                    }
                    return SizedBox(
                      height: _tileHeight,
                      child: ListTile(
                        title: Text(row.value, style: const TextStyle(fontSize: 14)),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
                        onTap: () => _onModelTap(row.value),
                      ),
                    );
                  },
                ),
                _buildAlphabetIndex(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHandle() {
    return Container(
      margin: const EdgeInsets.only(top: 10, bottom: 10),
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: "Поиск модели...",
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: const Color(0xFFF2F3F5),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildAlphabetIndex() {
    if (_alphabet.isEmpty) return const SizedBox.shrink();
    final chars = _alphabet;
    return Positioned(
      right: 5,
      top: 20,
      bottom: 20,
      child: Container(
        width: 30,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: chars.map((char) {
            return GestureDetector(
              onTap: () => _scrollToLetter(char),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Text(
                  char,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E6FF2),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _ListRow {
  final bool isHeader;
  final String value;
  _ListRow({required this.isHeader, required this.value});
}
