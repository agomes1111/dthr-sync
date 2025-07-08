import 'dart:developer';

import 'package:dthr_sync/single_clock.dart';
import 'package:dthr_sync/src/data/dto/runtime_loaded_data.dart';
import 'package:dthr_sync/src/data/repo/data_repo.dart';
import 'package:dthr_sync/src/data/service/sync_service.dart';
import 'package:dthr_sync/src/data/source/api_source.dart';
import 'package:dthr_sync/src/data/source/cache.dart';
import 'package:dthr_sync/src/data/source/runtime_loaded_data_singleton.dart';
import 'package:dthr_sync/src/domain/entities/runtime_data.dart';
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
    return InitPluginUseCase(
      null,
      Cache(),
      RuntimeLoadedDataSingleton(null),
    );
  }

  Clock call(
    String id,
    Settings settings,
  ) {
    if (settings.autoSync) {
      apiSource ??= ApiSource(settings);
      SyncUseCase(
          // starts sync timer when instanciated
          SyncService(
        singleton,
        apiSource!,
        settings,
      ));
    } else {
      if (singleton.loadedData == null) {
        singleton.loadedData = RuntimeLoadedData();
      }
      singleton.loadedData?.runtimeLoadedData.add(
        SingleRuntimeData(
          id: id,
          loadedClock: null,
          pluginSettings: settings,
        ),
      );
    }

    log(
        name: 'init_plugin_called_id:$id',
        'api_url: ${settings.api_url} - interval: ${settings.syncJobInterval}');
    return Clock(
      id,
      GetTimeUseCase(DataRepo(
        apiSource: apiSource,
        cache: cache,
        loadedDataSingleton: singleton,
      )),
    );
  }
}
