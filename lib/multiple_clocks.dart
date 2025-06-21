library dthr_sync;

export 'package:dthr_sync/src/data/dto/plugin_settings_dto.dart';

import 'dart:developer';
import 'package:dthr_sync/single_clock.dart';
import 'package:collection/collection.dart';

class MultipleClocksHandler {
  List<Clock> clocks = [];

  void updateClockTimeStampById(
    DateTime timeStamp,
    Duration ntwLatency,
    String id,
  ) async {
    Clock? clock = clocks.firstWhereOrNull((element) => element.id == id);
    if (clock != null) {
      log(name: 'updating_clock_timestamp_${id}', timeStamp.toString());
      clock.updateTimeStamp(timeStamp, ntwLatency);
    } else {
      log(name: '\n[err]updated_clock_timestamp_${id}', 'clock_not_found');
    }
  }

  Future<DateTime?> getTimeById(String id) async {
    Clock? clock = clocks.firstWhereOrNull((element) => element.id == id);
    if (clock != null) {
      DateTime? dthr = await clock.getTime();
      log(name: '\nmultiple_clocks_handler', 'clock_${id}_found_${dthr}');
      return dthr;
    } else {
      log(name: '\n[err]multiple_clocks_handler_${id}', 'clock_not_found');
      return null;
    }
  }

  bool hasClock(String id) {
    return clocks.firstWhereOrNull((element) => element.id == id) != null;
  }
}

MultipleClocksHandler? _clocksHandler;

MultipleClocksHandler get clocksHandler {
  if (_clocksHandler == null) {
    throw Exception('module_not_initialized_did_you_call_startClock()');
  } else
    return _clocksHandler!;
}

final Function startClock = (
  String id,
  Settings pluginSettings,
) {
  _clocksHandler ??= MultipleClocksHandler();
  Clock _clock = setupAppClock(id, pluginSettings);
  _clocksHandler!.clocks.add(_clock);
};
