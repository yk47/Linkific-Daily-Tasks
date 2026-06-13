import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ConfigService {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  // API Keys stored in secure storage (not hardcoded in source)
  static const String _apiKeyKey = 'watchmode_api_key';
  static const String _defaultApiKey = '3DYLf7uIDRSYD3xzeYPeZ9xLePRou8fPG7fRCagE';

  static Future<String> getApiKey() async {
    final stored = await _storage.read(key: _apiKeyKey);
    if (stored != null) return stored;
    // First run - store default key
    await _storage.write(key: _apiKeyKey, value: _defaultApiKey);
    return _defaultApiKey;
  }

  static Future<void> setApiKey(String key) async {
    await _storage.write(key: _apiKeyKey, value: key);
  }
}