import 'package:dthr_sync/src/domain/entities/plugin_settings.dart';

class Settings extends PluginSettings {
  Settings(super.api_url);

  factory Settings.fromCacheMock(String cacheMock) {
    return Settings('https://fake_cache_url.com');
  }
}
