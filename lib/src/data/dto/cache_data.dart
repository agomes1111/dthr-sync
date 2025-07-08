import 'package:dthr_sync/src/data/dto/plugin_settings_dto.dart';
import 'package:dthr_sync/src/data/dto/runtime_loaded_data.dart';
import 'package:dthr_sync/src/domain/entities/plugin_settings.dart';

class CacheData {
  PluginSettings pluginSettings;
  CacheData({
    required this.pluginSettings,
  });

  factory CacheData.fromCacheMock(String cacheJson) {
    return CacheData(
      pluginSettings: Settings.fromCacheMock(cacheJson),
    );
  }

  // TODO: implement CacheData.toJson();

  // RuntimeLoadedData toRuntimeData() {
  //   return RuntimeLoadedData(
  //     loadedClock: null,
  //     pluginSettings: this.pluginSettings,
  //   );
  // }

  @override
  CacheData toCache() {
    // TODO: implement toCache
    throw UnimplementedError();
  }
}
