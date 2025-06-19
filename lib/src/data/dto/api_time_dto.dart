import 'package:dthr_sync/src/data/dto/runtime_loaded_data.dart';
import 'package:dthr_sync/src/domain/entities/plugin_settings.dart';
import 'package:dthr_sync/src/domain/entities/synced_clock.dart';

class ApiTimeDto extends SyncedClock {
  ApiTimeDto({
    required super.serverTimestamp,
    required super.networkLatency,
    super.elapsedProv,
  });

  factory ApiTimeDto.fromCacheMock(String cacheJson) {
    return ApiTimeDto(
      networkLatency: const Duration(seconds: 1),
      serverTimestamp: DateTime.now(),
    );
  }

  SingleRuntimeData toRuntimeData(PluginSettings settings) {
    return SingleRuntimeData(
      loadedClock: this,
      pluginSettings: settings,
    );
  }
}
