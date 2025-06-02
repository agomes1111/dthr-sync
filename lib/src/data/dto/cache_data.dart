import 'package:dthr_sync/src/data/dto/api_time_dto.dart';
import 'package:dthr_sync/src/data/dto/plugin_settings_dto.dart';
import 'package:dthr_sync/src/data/dto/runtime_loaded_data.dart';
import 'package:dthr_sync/src/domain/entities/runtime_data.dart';

class CacheData extends RuntimeData {
  CacheData({
    required super.loadedClock,
    required super.pluginSettings,
  });

  factory CacheData.fromCacheMock(String cacheJson) {
    return CacheData(
      loadedClock: ApiTimeDto.fromCacheMock(cacheJson),
      pluginSettings: Settings.fromCacheMock(cacheJson),
    );
  }

  // TODO: implement CacheData.toJson();

  RuntimeLoadedData toRuntimeData() {
    return RuntimeLoadedData(
      loadedClock: this.loadedClock,
      pluginSettings: this.pluginSettings,
    );
  }
}
