/// Сервис для работы с Supabase. Инициализация при старте приложения.
class SupabaseService {
  static bool _initialized = false;
  static bool get isInitialized => _initialized;

  static Future<void> init() async {
    if (_initialized) return;
    // TODO: Добавить supabase_flutter и настроить
    // await Supabase.initialize(url: dotenv.env['SUPABASE_URL'], anonKey: dotenv.env['SUPABASE_ANON_KEY']);
    _initialized = true;
  }
}
