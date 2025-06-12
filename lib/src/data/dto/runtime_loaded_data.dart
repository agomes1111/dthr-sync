import 'package:dthr_sync/src/data/dto/cache_data.dart';
import 'package:dthr_sync/src/domain/entities/runtime_data.dart';

class RuntimeLoadedData extends RuntimeData {
  // ElapsedProvider _loadedTime;
  RuntimeLoadedData({
    required super.loadedClock,
    required super.pluginSettings,
  });
  // : _loadedTime = loadedClock

  CacheData toCache() {
    return CacheData(
      // loadedClock: loadedClock,
      pluginSettings: pluginSettings,
    );
  }
}
