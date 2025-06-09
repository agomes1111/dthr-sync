import 'dart:async';
import 'dart:developer';

import 'package:dthr_sync/src/data/dto/runtime_loaded_data.dart';
import 'package:dthr_sync/src/data/source/api_source.dart';
import 'package:dthr_sync/src/data/source/runtime_loaded_data_singleton.dart';
import 'package:dthr_sync/src/domain/entities/runtime_data.dart';

class SyncService {
  RuntimeLoadedDataSingleton singleton;
  late Timer job;
  ApiSource apiSource;

  SyncService(
    this.singleton,
    this.apiSource,
    int syncJobInterval,
  ) {
    job = Timer(
      Duration(minutes: syncJobInterval),
      () async {
        log(
          name: 'syncing_clock_timestamp_tick',
          job.tick.toString(),
        );
        await apiSource.getApiTimeMock();
      },
    );
  }

  Future syncStoredData(RuntimeData runtimeData) async {
    RuntimeData? loadedData = singleton.loadedData;

    if (loadedData != null &&
        (loadedData.pluginSettings.api_url != runtimeData.pluginSettings.api_url)) {
      print('overriding_runtime_existing_api_url_settings');
    }

    singleton.updateLoadedData = runtimeData as RuntimeLoadedData;
    print('syncing_runtime_xstored_data');
  }
}
