// lib/core/data/car_data.dart

/// Возвращает группу для сортировки: цифры → '#', иначе первая буква.
String getGroup(String s) {
  if (s.isEmpty) return '';
  if (RegExp(r'^[0-9]').hasMatch(s)) return '#';
  return s[0].toUpperCase();
}

/// Возвращает уникальные группы из списка (буквы + '#'), отсортированные.
List<String> getAlphabet(List<String> models) {
  return models
      .map((e) => getGroup(e))
      .where((c) => c.isNotEmpty)
      .toSet()
      .toList()
    ..sort((a, b) {
        if (a == '#' && b != '#') return 1;
        if (a != '#' && b == '#') return -1;
        return a.compareTo(b);
      });
}

/// Данные автомобилей для приложения BLOOMP
class CarData {
  /// Все бренды автомобилей (50+)
  static const Map<String, List<String>> brandModels = {
    'Toyota': [
      'Camry', 'Corolla', 'RAV4', 'Land Cruiser', 'Prado', 'Highlander',
      'Avalon', 'Yaris', 'Fortuner', 'Hilux', 'Alphard', 'Venza', 'C-HR'
    ],
    'Honda': [
      'Civic', 'Accord', 'CR-V', 'Pilot', 'Odyssey', 'HR-V', 'Fit',
      'Ridgeline', 'Passport', 'Insight'
    ],
    'Nissan': [
      'Altima', 'Maxima', 'Sentra', 'Murano', 'Pathfinder', 'Rogue',
      'Juke', 'Qashqai', 'X-Trail', 'Patrol', 'Armada', 'Leaf'
    ],
    'Mazda': [
      'Mazda3', 'Mazda6', 'CX-5', 'CX-9', 'CX-30', 'MX-5', 'CX-50'
    ],
    'Mitsubishi': [
      'Outlander', 'Pajero', 'Lancer', 'ASX', 'Eclipse Cross', 'Montero'
    ],
    'Subaru': [
      'Outback', 'Forester', 'Impreza', 'Legacy', 'Crosstrek', 'WRX', 'BRZ'
    ],
    'Lexus': [
      'ES', 'RX', 'GX', 'LX', 'NX', 'UX', 'IS', 'LS', 'LC', 'RC'
    ],
    'Hyundai': [
      'Accent', 'Elantra', 'Sonata', 'Tucson', 'Santa Fe', 'Palisade',
      'Kona', 'Venue', 'Ioniq', 'Genesis'
    ],
    'Kia': [
      'Rio', 'Optima', 'Sorento', 'Sportage', 'Telluride', 'Soul',
      'Seltos', 'Carnival', 'K5', 'Stinger'
    ],
    'BMW': [
      '3 Series', '5 Series', '7 Series', 'X1', 'X3', 'X5', 'X7',
      'i3', 'i4', 'iX', 'M3', 'M5'
    ],
    'Mercedes-Benz': [
      'A-Class', 'C-Class', 'E-Class', 'S-Class', 'GLA', 'GLC', 'GLE',
      'GLS', 'EQC', 'AMG GT'
    ],
    'Audi': [
      'A3', 'A4', 'A6', 'A8', 'Q3', 'Q5', 'Q7', 'Q8', 'e-tron', 'RS6'
    ],
    'Volkswagen': [
      'Jetta', 'Passat', 'Golf', 'Tiguan', 'Atlas', 'Arteon', 'ID.4', 'Polo'
    ],
    'Ford': [
      'F-150', 'Mustang', 'Explorer', 'Escape', 'Edge', 'Bronco',
      'Expedition', 'Ranger', 'Maverick'
    ],
    'Chevrolet': [
      'Silverado', 'Malibu', 'Equinox', 'Traverse', 'Tahoe', 'Suburban',
      'Blazer', 'Camaro', 'Corvette'
    ],
    'Jeep': [
      'Wrangler', 'Grand Cherokee', 'Cherokee', 'Compass', 'Renegade', 'Gladiator'
    ],
    'Dodge': [
      'Charger', 'Challenger', 'Durango', 'Journey'
    ],
    'Ram': [
      '1500', '2500', '3500', 'ProMaster'
    ],
    'Tesla': [
      'Model S', 'Model 3', 'Model X', 'Model Y'
    ],
    'Volvo': [
      'S60', 'S90', 'V60', 'V90', 'XC40', 'XC60', 'XC90', 'C40'
    ],
    'Land Rover': [
      'Range Rover', 'Range Rover Sport', 'Discovery', 'Defender', 'Evoque'
    ],
    'Porsche': [
      '911', 'Cayenne', 'Macan', 'Panamera', 'Taycan'
    ],
    'Infiniti': [
      'Q50', 'Q60', 'QX50', 'QX60', 'QX80'
    ],
    'Acura': [
      'TLX', 'MDX', 'RDX', 'ILX', 'NSX'
    ],
    'Genesis': [
      'G70', 'G80', 'G90', 'GV70', 'GV80'
    ],
    'Cadillac': [
      'Escalade', 'XT5', 'XT6', 'CT5', 'Lyriq'
    ],
    'Lincoln': [
      'Navigator', 'Aviator', 'Corsair', 'Nautilus'
    ],
    'Buick': [
      'Enclave', 'Encore', 'Envision'
    ],
    'GMC': [
      'Sierra', 'Yukon', 'Acadia', 'Terrain', 'Canyon'
    ],
    'Chrysler': [
      'Pacifica', '300'
    ],
    'Alfa Romeo': [
      'Giulia', 'Stelvio'
    ],
    'Maserati': [
      'Ghibli', 'Levante', 'Quattroporte'
    ],
    'Jaguar': [
      'XE', 'XF', 'F-Pace', 'E-Pace', 'I-Pace'
    ],
    'Bentley': [
      'Continental', 'Flying Spur', 'Bentayga'
    ],
    'Rolls-Royce': [
      'Ghost', 'Phantom', 'Cullinan'
    ],
    'Ferrari': [
      '488', 'F8', 'Roma', 'Portofino', 'SF90'
    ],
    'Lamborghini': [
      'Huracán', 'Aventador', 'Urus'
    ],
    'McLaren': [
      '570S', '720S', 'GT', 'Artura'
    ],
    'Aston Martin': [
      'DB11', 'Vantage', 'DBX'
    ],
    'Lotus': [
      'Evora', 'Elise', 'Emira'
    ],
    'Mini': [
      'Cooper', 'Countryman', 'Clubman'
    ],
    'Smart': [
      'Fortwo', 'Forfour'
    ],
    'Fiat': [
      '500', '500X', 'Tipo'
    ],
    'Peugeot': [
      '208', '308', '3008', '5008'
    ],
    'Renault': [
      'Clio', 'Megane', 'Captur', 'Koleos'
    ],
    'Citroën': [
      'C3', 'C4', 'C5', 'Berlingo'
    ],
    'Škoda': [
      'Octavia', 'Superb', 'Kodiaq', 'Karoq'
    ],
    'Seat': [
      'Leon', 'Ibiza', 'Ateca', 'Tarraco'
    ],
    'Opel': [
      'Corsa', 'Astra', 'Insignia', 'Crossland'
    ],
    'Suzuki': [
      'Swift', 'Vitara', 'Jimny', 'S-Cross'
    ],
    'Geely': [
      'Atlas', 'Coolray', 'Tugella', 'Monjaro'
    ],
    'Chery': [
      'Tiggo 4', 'Tiggo 7', 'Tiggo 8', 'Arrizo 6'
    ],
    'Haval': [
      'Jolion', 'F7', 'H6', 'H9'
    ],
    'BYD': [
      'Tang', 'Han', 'Song', 'Qin'
    ],
  };

  /// Совместимость: то же что brandModels (для старого кода)
  static Map<String, List<String>> get modelsByBrand => Map.from(brandModels);

  /// Удобство: модели Toyota
  static List<String> get toyotaModels => List.from(brandModels['Toyota'] ?? []);

  /// Получить список всех брендов
  static List<String> get brands => brandModels.keys.toList()..sort();

  /// Получить модели для бренда
  static List<String> getModels(String brand) {
    return brandModels[brand] ?? [];
  }

  /// Поиск брендов по запросу
  static List<String> searchBrands(String query) {
    if (query.isEmpty) return brands;

    final lowerQuery = query.toLowerCase();
    return brands
        .where((brand) => brand.toLowerCase().contains(lowerQuery))
        .toList();
  }

  /// Поиск моделей по запросу
  static List<String> searchModels(String brand, String query) {
    final models = getModels(brand);
    if (query.isEmpty) return models;

    final lowerQuery = query.toLowerCase();
    return models
        .where((model) => model.toLowerCase().contains(lowerQuery))
        .toList();
  }
}

/// Данные годов выпуска
class YearData {
  /// Все годы с 1980 до текущего + 1
  static List<int> get years {
    final currentYear = DateTime.now().year;
    return List.generate(
      currentYear - 1979 + 1,
      (index) => currentYear + 1 - index,
    );
  }

  /// Популярные годы (последние 11 лет)
  static List<int> get popularYears {
    final currentYear = DateTime.now().year;
    return List.generate(11, (index) => currentYear + 1 - index);
  }

  /// Диапазон годов
  static List<int> getYearRange(int fromYear, int toYear) {
    if (fromYear > toYear) {
      final temp = fromYear;
      fromYear = toYear;
      toYear = temp;
    }

    return List.generate(
      toYear - fromYear + 1,
      (index) => toYear - index,
    );
  }

  /// Минимальный год
  static const int minYear = 1980;

  /// Максимальный год (текущий + 1)
  static int get maxYear => DateTime.now().year + 1;
}
