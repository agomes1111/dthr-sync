import 'package:dthr_sync/single_clock.dart';
import 'package:dthr_sync/src/data/repo/data_repo.dart';
import 'package:dthr_sync/src/data/service/sync_service.dart';
import 'package:dthr_sync/src/data/source/api_source.dart';
import 'package:dthr_sync/src/data/source/cache.dart';
import 'package:dthr_sync/src/data/source/runtime_loaded_data_singleton.dart';
import 'package:dthr_sync/src/domain/use_case/get_time.dart';
import 'package:dthr_sync/src/domain/use_case/sync.dart';

class InitPluginUseCase {
  ApiSource? apiSource;
  Cache cache;
  RuntimeLoadedDataSingleton singleton;
  InitPluginUseCase(
    this.apiSource,
    this.cache,
    this.singleton,
  );

  factory InitPluginUseCase.base() {
    return InitPluginUseCase(null, Cache(), RuntimeLoadedDataSingleton(null));
  }

  Clock call(Settings settings) {
    apiSource ??= ApiSource(settings);
    // ApiSource apiSource = ApiSource(settings);
    // Cache cache = Cache();
    // RuntimeLoadedDataSingleton singleton = RuntimeLoadedDataSingleton(null);
    SyncUseCase(
        // starts sync timer when instanciated
        SyncService(
      singleton,
      apiSource!,
      settings,
    ));
    return Clock(
      GetTimeUseCase(DataRepo(
        apiSource: apiSource!,
        cache: cache,
        loadedDataSingleton: singleton,
      )),
    );
  }
}
