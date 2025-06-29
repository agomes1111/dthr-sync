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

  /// will not try to fetch API timestamp if its not loaded at runtime
  DateTime? getTimeByIdNoAsync(String id) {
    Clock? clock = clocks.firstWhereOrNull((element) => element.id == id);
    if (clock != null) {
      DateTime? dthr = clock.getTimeNoAsync();
      log(name: '\nmultiple_clocks_handler(no async)', 'clock_${id}_found_${dthr}');
      return dthr;
    } else {
      log(name: '\n[err]multiple_clocks_handler_${id}(no async)', 'clock_not_found');
      return null;
    }
  }

  /// will try to fetch API timestamp if its not loaded at runtime
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
    _clocksHandler = MultipleClocksHandler();
  }
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
