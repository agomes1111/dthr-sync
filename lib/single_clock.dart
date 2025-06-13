library dthr_sync;

export 'package:dthr_sync/src/data/dto/plugin_settings_dto.dart';

import 'package:dthr_sync/src/data/dto/plugin_settings_dto.dart';
import 'package:dthr_sync/src/domain/entities/runtime_data.dart';
import 'package:dthr_sync/src/domain/use_case/get_time.dart';
import 'package:dthr_sync/src/domain/use_case/init_plugin.dart';

class Clock {
  GetTimeUseCase _getTimeUseCase;
  Clock(
    this._getTimeUseCase,
  );

  Future<DateTime?> getTime() async {
    RuntimeData _runtimeData = await _getTimeUseCase.call();
    return _runtimeData.loadedClock?.currentTime;
  }
}

InitPluginUseCase _initPluginUseCase = InitPluginUseCase.base();

Clock? _clock;

Clock get clock {
  if (_clock == null) {
    throw Exception('package_not_initialized_did_you_call_setupClock()');
  } else
    return _clock!;
}

final Function setupAppClock = (Settings pluginSettings) {
  _clock = _initPluginUseCase.call(pluginSettings);
};
