import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../core/providers/garage_provider.dart';
import '../../../shared/models/my_vehicle.dart';

class CarSelectionSheet extends StatefulWidget {
  const CarSelectionSheet({super.key});

  static const List<String> toyotaModels = [
  "4Runner", "Agya", "Allex", "Allion", "Alphard", "Altezza", "Aqua", "Aristo",
  "Aurion", "Auris", "Avalon", "Avanza", "Avensis", "Avensis Verso", "Aygo", "bB",
  "Belta", "Blade", "Blizzard", "Brevis", "bZ3", "bZ3X", "bZ4X", "bZ5", "C-HR",
  "Caldina", "Cami", "Camry", "Camry Gracia", "Camry Prominent", "Carina",
  "Carina E", "Carina ED", "Carina II", "Cavalier", "Celica", "Celsior", "Century",
  "Chaser", "Corolla", "Corolla Axio", "Corolla Ceres", "Corolla Cross", "Corolla II",
  "Corolla Levin", "Corolla Rumion", "Corolla Verso", "Corona", "Corona Exiv", "Corsa",
  "Cressida", "Cresta", "Crown", "Crown Kluger", "Crown Majesta", "Curren", "Cynos",
  "Duet", "Echo", "Esquire", "Estima", "Estima Emina", "Estima Lucida", "FJ Cruiser",
  "Fortuner", "Frontlander", "Fun Cargo", "Gaia", "GR86", "Grand Hiace",
  "Grand Highlander", "Granvia", "GT 86", "Harrier", "Hiace", "HiAce Regius",
  "Highlander", "Hilux", "Hilux Champ", "Hilux Surf", "Innova", "Ipsum", "iQ",
  "Isis", "Ist", "Izoa", "Kluger", "Land Cruiser", "Land Cruiser Prado", "Levin",
  "Lite Ace", "Mark II", "Mark II Qualis", "Mark X", "Mark X Zio", "Master Ace Surf",
  "Matrix", "Mega Cruiser", "Mirai", "Model F", "MR-S", "MR2", "Nadia", "Noah",
  "Opa", "Paseo", "Passo", "Passo Sette", "Picnic", "Pixis Epoch", "Platz", "Porte",
  "Premio", "Previa", "Prius", "Prius C", "Prius Prime", "Prius V", "ProAce Verso",
  "Probox", "Progres", "Pronard", "Ractis", "Raize", "Raum", "RAV4", "Roomy",
  "Rumion", "Rush", "Sai", "Scepter", "Sequoia", "Sera", "Sienna", "Sienta",
  "Soarer", "Solara", "Spacio", "Spade", "Sparky", "Sprinter", "Sprinter Carib",
  "Sprinter Marino", "Sprinter Trueno", "Starlet", "Succeed",
];

  static const List<String> hondaModels = [
    "Accord", "Acty", "Airwave", "Ascot", "Avancier", "Ballade", "Beat", "City",
    "Civic", "Civic Type R", "Civic Ferio", "Clarity", "Concerto", "CR-V", "CR-X",
    "CR-Z", "Crossroad", "Crosstour", "Domani", "Edix", "Element", "Elysion", "Envix",
    "e:NS1", "e:NP1", "FCX Clarity", "Fit", "Fit Aria", "Fit Shuttle", "Freed",
    "Freed Spike", "Grace", "Horizon", "HR-V", "Insight", "Inspire", "Integra",
    "Integra SJ", "Jade", "Jazz", "Legend", "Life", "Logo", "MDX", "Mobilio",
    "Mobilio Spike", "NSX", "N-BOX", "N-ONE", "N-WGN", "Odyssey", "Orthia", "Partner",
    "Passport", "Pilot", "Prelude", "Quint", "Rafaga", "Ridgeline", "S-MX", "S2000",
    "Saber", "Shuttle", "Stepwgn", "Stream", "Street", "That'S", "Torneo", "Vamous",
    "Vezel", "Vigor", "Z", "Zest", "ZR-V",
  ];

  static const List<String> mitsubishiModels = [
    "3000 GT", "Airtrek", "AsPIRE", "ASX", "Carisma", "Challenger", "Chariot",
    "Chariot Grandis", "Colt", "Colt Plus", "Cordia", "Debonair", "Delica",
    "Delica D:2", "Delica D:3", "Delica D:5", "Diamante", "Dingo", "Dion", "Eclipse",
    "Eclipse Cross", "eK Custom", "eK Space", "eK Wagon", "Emeraude", "Endeavor",
    "Eterna", "FTO", "Galant", "Galant Fortis", "Grandis", "GTO", "i", "i-MiEV",
    "Jeep", "L200", "L300", "L400", "Lancer", "Lancer Evolution", "Lancer Cedia",
    "Legnum", "Libero", "Magna", "Minica", "Minicab", "Mirage", "Montero",
    "Montero Sport", "Outlander", "Outlander PHEV", "Pajero", "Pajero iO",
    "Pajero Junior", "Pajero Mini", "Pajero Pinin", "Pajero Sport", "RVR",
    "Sapporo", "Sigma", "Space Gear", "Space Runner", "Space Star", "Space Wagon",
    "Starion", "Strada", "Toppo", "Town Box", "Tredia", "Triton", "Xpander",
  ];

  static const List<String> nissanModels = [
    "100NX", "180SX", "200SX", "240SX", "300ZX", "350Z", "370Z", "AD", "Almera",
    "Almera Classic", "Almera Tino", "Altima", "Ariya", "Armada", "Avenir", "Bassara",
    "Be-1", "Bluebird", "Bluebird Sylphy", "Caravan", "Cedric", "Cefiro", "Cima",
    "Clipper", "Cube", "Datsun", "Dayz", "Dayz Roox", "Dualis", "Elgrand", "Expert",
    "Fairlady Z", "Figaro", "Fuga", "Gloria", "GT-R", "Juke", "Kicks", "Kix", "Lafesta",
    "Langley", "Largo", "Latio", "Laurel", "Leaf", "Leopard", "Liberta Villa", "Liberty",
    "Lucino", "March", "Maxima", "Micra", "Mistral", "Moco", "Murano", "Navara", "Note",
    "NP300", "NV100 Clipper", "NV200", "NV350 Caravan", "Otti", "Pao", "Pathfinder",
    "Patrol", "Pino", "Presage", "Presea", "President", "Primastar", "Primera", "Pulsar",
    "Qashqai", "Qashqai+2", "Quest", "R'nessa", "Rasheen", "Rogue", "Rogue Sport", "Roox",
    "Safari", "Sakura", "Sentra", "Serena", "Silvia", "Skyline", "Skyline GT-R", "Stagea",
    "Sunny", "Teana", "Terrano", "Terrano Regulus", "Tiida", "Tino", "Titan", "Urvan",
    "Vanette", "Vingroad", "X-Terra", "X-Trail", "Z",
  ];

static List<String> getYears() {
  return List.generate(2026 - 1980 + 1, (i) => (2026 - i).toString());
}

  static const List<String> allBrands = ["Toyota", "Nissan", "Honda", "Mitsubishi"];

  static Map<String, List<String>> get globalCarDatabase => {
        "Toyota": toyotaModels,
        "Nissan": nissanModels,
        "Honda": hondaModels,
        "Mitsubishi": mitsubishiModels,
      };

  @override
  State<CarSelectionSheet> createState() => _CarSelectionSheetState();
}

class _CarSelectionSheetState extends State<CarSelectionSheet> {
  int _currentStep = 0;
  String _selectedBrand = "";
  String _selectedModel = "";
  String _selectedYear = "";
  String _searchQuery = "";

  List<String> _getModelsForSelectedBrand() {
    return CarSelectionSheet.globalCarDatabase[_selectedBrand] ?? [];
  }

  List<String> get _filteredModels =>
      _getModelsForSelectedBrand()
          .where((m) => m.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();

  int _getItemCount() {
    if (_currentStep == 0) return CarSelectionSheet.allBrands.length;
    if (_currentStep == 1) return _filteredModels.length;
    if (_currentStep == 2) return CarSelectionSheet.getYears().length;
    return 0;
  }

  String _getItemTitle(int index) {
    if (_currentStep == 0) return CarSelectionSheet.allBrands[index];
    if (_currentStep == 1) return _filteredModels[index];
    if (_currentStep == 2) return CarSelectionSheet.getYears()[index];
    return "";
  }

  void _handleTap(String value) {
    setState(() {
      if (_currentStep == 0) {
        _selectedBrand = value;
        _currentStep = 1;
      } else if (_currentStep == 1) {
        _selectedModel = value;
        _currentStep = 2;
      } else if (_currentStep == 2) {
        _selectedYear = value;
        debugPrint("Автомобиль выбран: $_selectedBrand $_selectedModel, $_selectedYear г.");
        context.read<GarageProvider>().saveVehicle(
              MyVehicle(
                brand: _selectedBrand,
                model: _selectedModel,
                year: _selectedYear,
              ),
            );
        Navigator.pop(context);
        return;
      }
      _searchQuery = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          _buildHeader(),
          if (_currentStep == 1)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Поиск модели (например, Mark II)",
                  prefixIcon: const Icon(Icons.search),
                  fillColor: Colors.grey[100],
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (val) => setState(() => _searchQuery = val),
              ),
            ),
          Expanded(
            child: _currentStep == 0
                ? GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(2, 0, 2, 0),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      mainAxisSpacing: 1,
                      crossAxisSpacing: 1,
                      childAspectRatio: 1.0,
                    ),
                    itemCount: CarSelectionSheet.globalCarDatabase.keys.length,
                    itemBuilder: (context, index) {
                      final brandName =
                          CarSelectionSheet.globalCarDatabase.keys.elementAt(index);
                      return InkWell(
                        onTap: () {
                          HapticFeedback.lightImpact();
                          _handleTap(brandName);
                        },
                        child: Stack(
                          alignment: Alignment.topCenter,
                          children: [
                            Container(
                              height: 98,
                              width: 98,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF0F2F5),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                    color: Colors.grey.withOpacity(0.1),
                                    width: 0.5),
                              ),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 15),
                                  child: Icon(
                                    Icons.directions_car_filled,
                                    color: const Color(0xFF1976D2),
                                    size: 82,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 6,
                              child: Text(
                                brandName.toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black87,
                                  letterSpacing: -0.5,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: _getItemCount(),
                    itemBuilder: (context, index) {
                      final title = _getItemTitle(index);
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                        title: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey),
                        onTap: () => _handleTap(title),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    String title = "Выберите марку";
    if (_currentStep == 1) title = "Выберите модель $_selectedBrand";
    if (_currentStep == 2) title = "Выберите год для $_selectedModel";

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          if (_currentStep > 0)
            IconButton(
              icon: const Icon(Icons.arrow_back_rounded),
              onPressed: () => setState(() {
                _currentStep--;
                _searchQuery = "";
              }),
            ),
          Expanded(
            child: Text(
              title,
              textAlign: _currentStep > 0 ? TextAlign.left : TextAlign.center,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close_rounded),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}
