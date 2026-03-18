import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../../core/data/mock_products.dart';
import '../../../shared/widgets/auto_scrolling_banner.dart';
import '../../catalog/mock_data.dart';
import '../../../core/providers/garage_provider.dart';
import '../../../shared/models/my_vehicle.dart';
import '../../catalog/screens/search_results_screen.dart';
import '../../search/screens/search_screen.dart';
import '../../services/screens/vin_scanner_screen.dart';
import '../widgets/product_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _draggedAddress = "Определение адреса...";
  Timer? _debounce;
  StateSetter? _addressPickerSetState;
  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(43.238, 76.945),
    zoom: 16,
  );
  GoogleMapController? _mapController;
  CameraPosition? _lastCameraPosition;
  static const List<String> _headerAds = [
    'БЕСПЛАТНАЯ ДИАГНОСТИКА ХОДОВОЙ',
    'СКИДКИ НА МАСЛА ДО -30% ДО КОНЦА МАРТА',
    'ЗАПИСЬ НА ШИНОМОНТАЖ БЕЗ ОЧЕРЕДИ',
    'КЕШБЭК 5% БОНУСАМИ ЗА КАЖДУЮ ПОКУПКУ',
  ];
  int _currentAdIndex = 0;
  Timer? _headerAdTimer;

  @override
  void initState() {
    super.initState();
    _updateLocation();
    _headerAdTimer = Timer.periodic(const Duration(seconds: 8), (timer) {
      if (!mounted) return;
      setState(() => _currentAdIndex = (_currentAdIndex + 1) % _headerAds.length);
    });
  }

  @override
  void dispose() {
    _headerAdTimer?.cancel();
    _debounce?.cancel();
    _mapController?.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Widget _buildInteractiveMap() {
    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: _initialPosition,
          onMapCreated: (controller) {
            _mapController = controller;
            _lastCameraPosition = _initialPosition;
          },
          onCameraMove: (position) {
            _lastCameraPosition = position;
            if (_draggedAddress != "Поиск адреса...") {
              setState(() => _draggedAddress = "Поиск адреса...");
              _addressPickerSetState?.call(() {});
            }
          },
          onCameraIdle: () {
            _debounce?.cancel();
            _debounce = Timer(const Duration(milliseconds: 500), () {
              final pos = _lastCameraPosition;
              if (pos != null) {
                _fetchAddressFromCoords(pos.target.latitude, pos.target.longitude);
              }
            });
          },
        ),
        const Center(
          child: Padding(
            padding: EdgeInsets.only(bottom: 35),
            child: Icon(Icons.location_on, size: 45, color: Color(0xFFF91155)),
          ),
        ),
        Positioned(
          right: 16,
          bottom: 16,
          child: FloatingActionButton(
            backgroundColor: Colors.white,
            mini: true,
            onPressed: _updateLocation,
            child: const Icon(Icons.my_location, color: Colors.black54),
          ),
        ),
      ],
    );
  }

  Future<void> _updateLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.deniedForever ||
          permission == LocationPermission.denied) {
        if (!mounted) return;
        setState(() => _draggedAddress = "Разрешите доступ к геолокации");
        _addressPickerSetState?.call(() {});
        return;
      }
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
      );
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        final String city = place.locality ?? "";
        final String district = (place.subLocality != null && place.subLocality!.isNotEmpty)
            ? place.subLocality!
            : (place.subAdministrativeArea ?? "");
        final String street = place.thoroughfare ?? "";
        final String house = place.subThoroughfare ?? place.name ?? "";
        final List<String> parts = [city, district, street, house]
            .where((s) => s.isNotEmpty)
            .toList();
        final String address = parts.join(", ");
        if (!mounted) return;
        setState(() => _draggedAddress = address.isNotEmpty ? address : "Адрес не найден");
        _addressPickerSetState?.call(() {});
      }
      if (_mapController != null) {
        _mapController!.animateCamera(
          CameraUpdate.newLatLng(LatLng(position.latitude, position.longitude)),
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _draggedAddress = "Ошибка геопозиции");
      _addressPickerSetState?.call(() {});
      debugPrint("$e");
    }
  }

  Future<void> _fetchAddressFromCoords(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isEmpty) throw Exception("No placemarks");
      Placemark place = placemarks[0];
      final String city = place.locality ?? "";
      final String district = (place.subLocality != null && place.subLocality!.isNotEmpty)
          ? place.subLocality!
          : (place.subAdministrativeArea ?? "");
      final String street = place.thoroughfare ?? "";
      final String house = place.subThoroughfare ?? place.name ?? "";
      final List<String> parts = [city, district, street, house]
          .where((s) => s.isNotEmpty)
          .toList();
      final String address = parts.join(", ");
      if (!mounted) return;
      setState(() => _draggedAddress = address.isNotEmpty ? address : "Адрес не найден");
      _addressPickerSetState?.call(() {});
    } catch (e) {
      if (!mounted) return;
      setState(() => _draggedAddress = "Адрес не найден");
      _addressPickerSetState?.call(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final products = MockData.getProducts().toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // 1. ШАПКА С ПОИСКОМ
          SliverToBoxAdapter(child: _buildWBHeader(context)),
          // 2. ОТСТУП И БАННЕРЫ
          const SliverToBoxAdapter(child: SizedBox(height: 8)),
          const SliverToBoxAdapter(child: AutoScrollingBanner()),
          // 3. ГАРАЖ + СЕРВИСЫ (СТО, Мойка и т.д.)
          const SliverToBoxAdapter(child: SizedBox(height: 8)),
          SliverToBoxAdapter(child: _buildCombinedGarageAndServices()),
          // 4. НИЖНИЙ ОТСТУП
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
          // 5. СЕТКА ТОВАРОВ
          SliverPadding(
            padding: EdgeInsets.zero,
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 0,
                crossAxisSpacing: 1,
                childAspectRatio: 0.60,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final product = products[index % products.length];
                  return ProductCard(
                    key: ValueKey(index),
                    product: product,
                  );
                },
                childCount: products.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWBHeader(BuildContext context) {
    final double topPadding = MediaQuery.of(context).padding.top;

    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(10),
        bottomRight: Radius.circular(10),
      ),
      child: Container(
        height: 240,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF91155), Color(0xFFD30A4A)],
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(16, topPadding + 10, 16, 0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(onTap: () => _showAddressPicker(context), child: _buildAutoAddress()),
                      _buildLoginButton(context),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _buildSearchField(),
                  const SizedBox(height: 2),
                ],
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.12),
                ),
                child: ClipRRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Center(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 800),
                        child: Text(
                          _headerAds[_currentAdIndex],
                          key: ValueKey<int>(_currentAdIndex),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAutoAddress() {
    return Row(
      children: [
        const Icon(Icons.location_on, color: Colors.white, size: 18),
        const SizedBox(width: 6),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 250),
          child: Text(
            _draggedAddress,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/login'),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.8),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Text(
          'Войти',
          style: TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: _searchController,
        onSubmitted: (_) => _performSearch(),
        textAlign: TextAlign.left,
        cursorColor: Colors.pink,
        decoration: InputDecoration(
          hintText: 'Искать на Bloomp',
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
          prefixIcon: const Icon(Icons.search, color: Colors.grey, size: 20),
          suffixIcon: Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _buildSearchTool(Icons.auto_awesome, "AI"),
                const SizedBox(width: 10),
                _buildSearchTool(Icons.mic_none, "Voice"),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () async {
                    final scannedVin = await Navigator.push<String>(
                      context,
                      MaterialPageRoute(builder: (context) => const VinScannerScreen()),
                    );
                    if (scannedVin != null && mounted) {
                      _searchController.text = scannedVin;
                    }
                  },
                  child: const Icon(Icons.camera_alt_outlined, color: Colors.blueGrey, size: 20),
                ),
              ],
            ),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 10),
          isDense: true,
        ),
      ),
    );
  }

  Widget _buildSearchTool(IconData icon, String tooltip) {
    return GestureDetector(
      onTap: () => debugPrint("Tap on $tooltip"),
      child: Icon(icon, color: Colors.grey.shade600, size: 20),
    );
  }

  void _showAddressPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          _addressPickerSetState = setModalState;
          return Container(
            height: MediaQuery.of(context).size.height * 0.85,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
            ),
            child: Column(
              children: [
                const SizedBox(height: 12),
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close),
                      ),
                      const Text(
                        "Куда доставить?",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Поиск адреса",
                      prefixIcon: const Icon(Icons.search, color: Color(0xFFF91155)),
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: _buildInteractiveMap(),
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.location_on, color: Color(0xFFF91155)),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              _draggedAddress,
                              style: const TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF91155),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            "Подтвердить",
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    ).then((_) => _addressPickerSetState = null);
  }

  void _openCarSelection(BuildContext context) {
    Navigator.pushNamed(context, '/add_vehicle');
  }

  Widget _buildCombinedGarageAndServices() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildGarageSection(context),
          const Divider(height: 1, thickness: 0.5, color: Color(0xFFF5F5F5), indent: 16, endIndent: 16),
          _buildServiceGrid(),
        ],
      ),
    );
  }

  Widget _buildGarageSection(BuildContext context) {
    final provider = context.watch<GarageProvider>();
    final vehicle = provider.selectedVehicle;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2E6FF2).withOpacity(0.1)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
      ),
      child: vehicle == null
          ? _buildAddVehiclePrompt(context)
          : _buildActiveVehicle(context, vehicle),
    );
  }

  Widget _buildAddVehiclePrompt(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.directions_car_outlined, color: Color(0xFF2E6FF2), size: 30),
        const SizedBox(width: 12),
        const Expanded(
          child: Text(
            "Добавьте авто, чтобы быстрее находить запчасти",
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
          ),
        ),
        ElevatedButton(
          onPressed: () => _openCarSelection(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2E6FF2),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            elevation: 0,
          ),
          child: const Text("Добавить", style: TextStyle(color: Colors.white, fontSize: 12)),
        ),
      ],
    );
  }

  Widget _buildActiveVehicle(BuildContext context, MyVehicle vehicle) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
            color: Color(0xFFF2F3F5),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.garage, color: Colors.blue),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${vehicle.brand} ${vehicle.model}",
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              Text(
                vehicle.year,
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        ),
        TextButton(
          onPressed: () => _openCarSelection(context),
          child: const Text("Изменить", style: TextStyle(color: Color(0xFFF91155))),
        ),
      ],
    );
  }

  Widget _buildServiceGrid() {
    final List<Map<String, dynamic>> services = [
      {'name': 'СТО', 'icon': Icons.build_circle_outlined, 'badge': ''},
      {'name': 'Мойка', 'icon': Icons.local_car_wash_outlined, 'badge': ''},
      {'name': 'Эвакуатор', 'icon': Icons.support_rounded, 'badge': ''},
      {'name': 'Страховка', 'icon': Icons.verified_user_outlined, 'badge': 'NEW'},
      {'name': 'Бонусы', 'icon': Icons.stars_rounded, 'badge': '-20%'},
      {'name': 'Штрафы', 'icon': Icons.assignment_late_outlined, 'badge': '2'},
      {'name': 'Запчасти', 'icon': Icons.settings_suggest_outlined, 'badge': ''},
      {'name': 'Шины', 'icon': Icons.panorama_fish_eye, 'badge': ''},
      {'name': 'Масла', 'icon': Icons.opacity_outlined, 'badge': ''},
    ];
    return Container(
      width: double.infinity,
      height: 90,
      decoration: const BoxDecoration(color: Colors.white),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
        itemCount: services.length,
        itemBuilder: (context, index) {
          final item = services[index];
          final badge = item['badge'] as String;
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: InkWell(
              onTap: () => _handleServiceTap(item['name'] as String),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFDE7EE),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          item['icon'] as IconData,
                          color: const Color(0xFFF91155),
                          size: 28,
                        ),
                      ),
                      if (badge.isNotEmpty)
                        Positioned(
                          top: -4,
                          right: -4,
                          child: _buildBadge(badge),
                        ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item['name'] as String,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(
        color: text == 'NEW' ? Colors.blue : const Color(0xFFF91155),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 9,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }

  void _handleServiceTap(String name) {
    debugPrint('Переход в сервис: $name');
  }

  void _performSearch() {
    final query = _searchController.text.trim();
    if (query.isEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SearchScreen()),
      );
      return;
    }
    _searchWithQuery(query);
  }

  void _searchWithQuery(String query) {
    setState(() => _searchController.text = query);
    FocusScope.of(context).unfocus();
    final results = MockData.searchProducts(query);
    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SearchResultsScreen(
            query: query,
            results: results,
          ),
        ),
      );
    }
  }
}
