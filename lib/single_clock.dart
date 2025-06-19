library dthr_sync;

export 'package:dthr_sync/src/data/dto/plugin_settings_dto.dart';

import 'dart:developer';

import 'package:dthr_sync/src/data/dto/plugin_settings_dto.dart';
import 'package:dthr_sync/src/data/dto/runtime_clock.dart';
import 'package:dthr_sync/src/data/source/runtime_loaded_data_singleton.dart';
import 'package:dthr_sync/src/domain/entities/runtime_data.dart';
import 'package:dthr_sync/src/domain/use_case/get_time.dart';
import 'package:dthr_sync/src/domain/use_case/init_plugin.dart';

late InitPluginUseCase _initPluginUseCase;

class Clock {
  String id;
  GetTimeUseCase _getTimeUseCase;
  Clock(
    this.id,
    this._getTimeUseCase,
  );

  Future<DateTime?> getTime() async {
    RuntimeData _runtimeData = await _getTimeUseCase.call(this.id);
    return _runtimeData.loadedClock?.currentTime;
  }

  void updateTimeStamp(
    DateTime timeStamp,
    Duration networkLatency,
  ) {
    RuntimeLoadedDataSingleton runtimeLoadedDataSingleton = RuntimeLoadedDataSingleton(null);
    int i = runtimeLoadedDataSingleton.loadedData?.runtimeLoadedData
            .indexWhere((data) => data.id == this.id) ??
        -1;
    if (i != -1) {
      runtimeLoadedDataSingleton.loadedData?.runtimeLoadedData[i].loadedClock = RuntimeClock(
        serverTimestamp: timeStamp,
        networkLatency: networkLatency,
      );
    } else {
      log(
        name: '[err]update_time_stamp_${this.id}',
        'loaded_clock_not_found',
      );
    }
  }
}

Clock? _clock;

Clock get clock {
  if (_clock == null) {
    throw Exception('package_not_initialized_did_you_call_setupClock()');
  } else
    return _clock!;
}

final Function setupAppClock = (
  String id,
  Settings pluginSettings,
) {
  _initPluginUseCase = InitPluginUseCase.base();
  _clock = _initPluginUseCase.call(id, pluginSettings);
  return _clock;
};
