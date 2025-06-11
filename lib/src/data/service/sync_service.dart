import 'dart:async';
import 'dart:developer';

import 'package:dthr_sync/src/data/dto/api_time_dto.dart';
import 'package:dthr_sync/src/data/dto/plugin_settings_dto.dart';
import 'package:dthr_sync/src/data/dto/runtime_loaded_data.dart';
import 'package:dthr_sync/src/data/source/api_source.dart';
import 'package:dthr_sync/src/data/source/runtime_loaded_data_singleton.dart';
import 'package:dthr_sync/src/domain/entities/runtime_data.dart';

class SyncService {
  RuntimeLoadedDataSingleton singleton;
  Settings settings;
  late Timer job;
  ApiSource apiSource;

  SyncService(
    this.singleton,
    this.apiSource,
    this.settings,
  ) {
    job = Timer.periodic(
      Duration(seconds: settings.syncJobInterval),
      (_) async {
        if (singleton.lock) {
          log(
            name: 'skiping_sync_tick_${_.tick}_locked_by_previous_call',
            job.tick.toString(),
          );
          return;
        }
        log(
          name: 'syncing_clock_timestamp_tick_${_.tick}',
          job.tick.toString(),
        );
        try {
          singleton.lock = true;
          ApiTimeDto r = await apiSource.getSvTimeStamp();
          await syncStoredData(r.toRuntimeData(settings));
        } catch (err) {
          log(
            name: 'syncing_clock_timestamp_tick_${_.tick}_err',
            err.toString(),
          );
        } finally {
          singleton.lock = false;
        }
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
