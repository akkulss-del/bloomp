class VinDecoderService {
  static const Map<String, String> _wmiBrands = {
    'LB1': 'Geely',
    'LZE': 'Isizu',
    'LNV': 'BYD',
    'LTV': 'Toyota (China)',
    'LFB': 'Lifan',
    'LSY': 'Brilliance',
    'WP0': 'Porsche',
    'ZFF': 'Ferrari',
    'WBA': 'BMW',
    'XTA': 'Lada',
    'KL3': 'Chevrolet',
  };

  static Map<String, String>? decode(String vin) {
    if (vin.length < 17) return null;

    final cleanVin = vin.trim().toUpperCase();
    final wmi = cleanVin.substring(0, 3);
    final brand = _wmiBrands[wmi] ?? "Неизвестная марка";

    final yearChar = cleanVin.substring(9, 10);
    final year = _decodeYear(yearChar);

    return {
      'brand': brand,
      'year': year,
      'model': 'Определяется по каталогу...',
    };
  }

  static String _decodeYear(String char) {
    const years = {
      'N': '2022',
      'P': '2023',
      'R': '2024',
      'S': '2025',
    };
    return years[char] ?? "Год не определен";
  }
}
