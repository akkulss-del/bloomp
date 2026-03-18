import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/data/mock_products.dart';
import '../mock_data.dart';
import '../../../core/providers/garage_provider.dart';
import '../car_data.dart';
import '../../../shared/models/my_vehicle.dart';
import '../../services/screens/vin_scanner_screen.dart';
import '../widgets/toyota_model_picker.dart';
import 'category_products_screen.dart';

class CarModelsScreen extends StatefulWidget {
  final String brandName;

  const CarModelsScreen({super.key, required this.brandName});

  @override
  State<CarModelsScreen> createState() => _CarModelsScreenState();
}

class _CarModelsScreenState extends State<CarModelsScreen> {
  static final Map<String, List<String>> _modelsByBrand = {
    ...CarData.modelsByBrand,
    'BMW': ['3 Series', '5 Series', 'X3', 'X5', 'X7', '1 Series'],
    'Mercedes': [
      'A-Class', 'B-Class', 'C-Class', 'CLA', 'CLS', 'E-Class', 'G-Class',
      'GLA', 'GLB', 'GLC', 'GLE', 'GLS', 'S-Class', 'SL', 'V-Class', 'AMG GT',
    ],
    'Audi': ['A3', 'A4', 'A6', 'Q5', 'Q7', 'A1'],
    'Lexus': ['ES', 'RX', 'NX', 'LX', 'IS', 'LC'],
    'Nissan': ['Qashqai', 'X-Trail', 'Patrol', 'Juke', 'Kicks', 'Leaf'],
    'Geely': ['Atlas', 'Coolray', 'Monjaro', 'Tugella', 'Geometry C', 'Okavango'],
    'Haval': ['F7', 'Jolion', 'Dargo', 'H6', 'F7x', '初恋'],
    'Changan': ['CS75', 'Uni-K', 'CS55', 'CS35', 'Eado', 'Alsvin'],
    'Hyundai': ['Solaris', 'Tucson', 'Santa Fe', 'Creta', 'Palisade', 'Elantra'],
    'Kia': ['Rio', 'Sportage', 'Sorento', 'Cerato', 'Seltos', 'Stinger'],
  };

  List<String> get _models =>
      _modelsByBrand[widget.brandName] ?? ['Camry', 'RAV4', 'Corolla', 'Land Cruiser'];

  void _openVinScanner(BuildContext context) async {
    final vin = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (_) => const VinScannerScreen()),
    );
    if (vin != null && context.mounted) {
      // TODO: Расшифровать VIN через API → brand, model, year
      final gp = context.read<GarageProvider>();
      gp.saveVehicleFromVin(vin, MyVehicle(brand: widget.brandName, model: vin, year: "—"));
      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Автомобиль $vin добавлен в гараж"),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _selectModel(String model) => _showYearPicker(context, model);

  void _showYearPicker(BuildContext context, String model) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            "Выберите поколение $model",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          _yearItem(context, model, "XV70 (2017 - 2024)"),
          _yearItem(context, model, "XV50 (2011 - 2018)"),
          _yearItem(context, model, "XV40 (2006 - 2011)"),
        ],
      ),
    );
  }

  Widget _yearItem(BuildContext context, String model, String text) {
    return ListTile(
      title: Text(text),
      onTap: () {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategoryProductsScreen(
              categoryName: '${widget.brandName} $model',
              products: MockData.getProducts(),
            ),
          ),
        );
      },
    );
  }

  void _showAllModels(BuildContext context, String brand, List<String> models) {
    showToyotaModelPicker(
      context,
      brandName: brand,
      models: models,
      onModelSelected: (model) {
        Navigator.pop(context);
        _selectModel(model);
      },
    );
  }

  Widget _buildVinPromoCard(String brandName) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F7FF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.qr_code_scanner, color: Colors.blue, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Есть VIN-код $brandName?",
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const Text(
                  "Точность подбора 100%",
                  style: TextStyle(fontSize: 11, color: Colors.blueGrey),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () => _openVinScanner(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text("Ввести", style: TextStyle(color: Colors.white, fontSize: 12)),
          ),
        ],
      ),
    );
  }

  Widget _buildModelButton(String model) {
    return OutlinedButton(
      onPressed: () => _selectModel(model),
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: Colors.grey[200]!),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Text(
        model,
        style: const TextStyle(
          fontSize: 11,
          color: Colors.black87,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildModelsGrid() {
    final allModels = _models;
    final topModels = allModels.take(6).toList();
    final hasMore = allModels.length > 6;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildVinPromoCard(widget.brandName),
          const SizedBox(height: 20),
          const Text(
            "Или выберите модель вручную:",
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.grey),
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 2.6,
            ),
            itemCount: topModels.length,
            itemBuilder: (context, index) => _buildModelButton(topModels[index]),
          ),
          if (hasMore)
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 12),
                child: TextButton.icon(
                  onPressed: () => _showAllModels(context, widget.brandName, allModels),
                  icon: const Icon(Icons.keyboard_arrow_down, color: Colors.blue, size: 18),
                  label: const Text(
                    "Все модели",
                    style: TextStyle(fontSize: 13, color: Colors.blue, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      appBar: AppBar(
        title: Text(widget.brandName),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: _buildModelsGrid(),
      ),
    );
  }
}
