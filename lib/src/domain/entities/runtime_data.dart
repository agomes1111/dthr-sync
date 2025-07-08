import 'dart:developer';

import 'package:dthr_sync/src/data/dto/cache_data.dart';
import 'package:dthr_sync/src/domain/entities/plugin_settings.dart';
import 'package:dthr_sync/src/domain/entities/synced_clock.dart';

abstract class RuntimeData {
  String? id;
  PluginSettings pluginSettings;
  SyncedClock? loadedClock;
  RuntimeData({
    this.id,
    required this.loadedClock,
    required this.pluginSettings,
  }) {
    log(
        name: 'loaded_runtime_data_${DateTime.now()}',
        '${this.loadedClock} | ${this.pluginSettings}');
  }
  CacheData toCache();
}
