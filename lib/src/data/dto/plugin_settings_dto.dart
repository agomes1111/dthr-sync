import 'package:dthr_sync/src/domain/entities/plugin_settings.dart';

class Settings implements PluginSettings {
  @override
  String api_url;

  @override
  bool autoSync;

  @override
  int syncJobInterval;

  Settings({
    required this.api_url,
    required this.autoSync,
    required this.syncJobInterval,
  });

  factory Settings.fromCacheMock(String cacheMock) {
    return Settings(
      api_url: 'https://fake_cache_url.com',
      autoSync: true,
      syncJobInterval: 1,
    );
  }
}
