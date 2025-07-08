import 'package:dthr_sync/src/data/dto/cache_data.dart';
import 'package:dthr_sync/src/domain/entities/plugin_settings.dart';
import 'package:dthr_sync/src/domain/entities/runtime_data.dart';
import 'package:dthr_sync/src/domain/entities/synced_clock.dart';

class RuntimeLoadedData {
  List<SingleRuntimeData> runtimeLoadedData = [];
}

class SingleRuntimeData implements RuntimeData {
  @override
  String? id;

  @override
  SyncedClock? loadedClock;

  @override
  PluginSettings pluginSettings;

  SingleRuntimeData({
    this.id,
    required this.loadedClock,
    required this.pluginSettings,
  });

  @override
  CacheData toCache() {
    // TODO: implement toCache
    throw UnimplementedError();
  }
}
