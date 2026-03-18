// lib/main.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'core/services/supabase_service.dart';
import 'core/providers/auth_provider.dart';
import 'core/providers/cart_provider.dart';
import 'core/providers/favorites_provider.dart';
import 'core/providers/garage_provider.dart';

import 'features/home/screens/splash_screen.dart';
import 'features/home/screens/home_screen.dart';
import 'features/catalog/screens/catalog_screen.dart';
import 'features/catalog/screens/product_detail_screen.dart';
import 'features/cart/screens/cart_screen.dart';
import 'features/cart/screens/checkout_screen.dart';
import 'features/cart/screens/order_success_screen.dart';
import 'features/profile/screens/profile_screen.dart';
import 'features/profile/screens/settings_screen.dart';
import 'features/favorites/screens/favorites_screen.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/auth/screens/register_screen.dart';
import 'features/garage/screens/garage_screen.dart';
import 'features/garage/screens/add_vehicle_screen.dart';
import 'features/garage/screens/add_car_screen.dart';
import 'features/promo/screens/banner_grid_screen.dart';
import 'features/search/screens/image_search_screen.dart';
import 'features/search/screens/voice_search_screen.dart';
import 'features/chat/screens/chatbot_screen.dart';
import 'features/admin/screens/export_catalog_screen.dart';
import 'shared/models/product.dart';
import 'shared/widgets/bottom_nav_bar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    debugPrint('⚠️ .env not found: $e');
  }

  await Hive.initFlutter();

  try {
    await SupabaseService.init();
    debugPrint('✅ Supabase initialized');
  } catch (e) {
    debugPrint('⚠️ Supabase init failed: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
        ChangeNotifierProvider(create: (_) => GarageProvider()),
      ],
      child: MaterialApp(
        title: 'BLOOMP',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFF91155)),
          useMaterial3: true,
        ),
        initialRoute: '/splash',
        routes: {
          '/splash': (context) => const SplashScreen(),
          '/home': (context) => const MainNavigator(),
          '/catalog': (context) => const CatalogScreen(),
          '/cart': (context) => const CartScreen(),
          '/checkout': (context) => const CheckoutScreen(),
          '/order_success': (context) => const OrderSuccessScreen(),
          '/favorites': (context) => const FavoritesScreen(),
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/garage': (context) => const GarageScreen(),
          '/add_vehicle': (context) => const AddVehicleScreen(),
          '/add_car': (context) => const AddCarScreen(),
          '/banner_grid': (context) => const BannerGridScreen(),
          '/settings': (context) => const SettingsScreen(),
          '/image_search': (context) => const ImageSearchScreen(),
          '/voice_search': (context) => const VoiceSearchScreen(),
          '/chatbot': (context) => const ChatbotScreen(),
          '/export_catalog': (context) => const ExportCatalogScreen(),
          '/product-detail': (context) {
            final product = ModalRoute.of(context)!.settings.arguments as Product;
            return ProductDetailScreen(product: product);
          },
        },
      ),
    );
  }
}

class MainNavigator extends StatefulWidget {
  const MainNavigator({super.key});

  @override
  State<MainNavigator> createState() => _MainNavigatorState();
}

class _MainNavigatorState extends State<MainNavigator> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    CatalogScreen(),
    ProfileScreen(),
  ];

  int get _navIndex => _currentIndex == 0 ? 0 : (_currentIndex == 1 ? 1 : 4);

  void _showAddOptionsBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Что вы хотите добавить?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF91155).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.add_shopping_cart, color: Color(0xFFF91155)),
              ),
              title: const Text('Добавить объявление'),
              subtitle: const Text('Продать запчасть'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.directions_car, color: Colors.blue),
              ),
              title: const Text('Добавить автомобиль'),
              subtitle: const Text('В мой гараж'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/add_vehicle');
              },
            ),
          ],
        ),
      ),
    );
  }

  void _onNavTap(int index) {
    if (index == 2) {
      _showAddOptionsBottomSheet();
      return;
    }
    if (index == 3) {
      Navigator.pushNamed(context, '/cart');
      return;
    }
    setState(() {
      _currentIndex = index == 4 ? 2 : index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _navIndex,
        onTap: _onNavTap,
        onCenterTap: _showAddOptionsBottomSheet,
      ),
    );
  }
}
