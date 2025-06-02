import 'package:dthr_sync/src/domain/entities/plugin_settings.dart';
import 'package:dthr_sync/src/domain/entities/runtime_data.dart';
import 'package:dthr_sync/src/domain/entities/synced_clock.dart';

class RuntimeLoadedData extends RuntimeData {
  // ElapsedProvider _loadedTime;
  RuntimeLoadedData({
    required super.loadedClock,
    required super.pluginSettings,
  });
  // : _loadedTime = loadedClock
}
