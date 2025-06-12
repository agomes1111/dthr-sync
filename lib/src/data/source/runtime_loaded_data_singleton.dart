import 'dart:developer';

import 'package:dthr_sync/src/data/dto/runtime_loaded_data.dart';

typedef Lock = bool;

class RuntimeLoadedDataSingleton {
  static RuntimeLoadedDataSingleton? _instance;

  /// nullable so plugin can load without any loaded data
  RuntimeLoadedData? _loadedData;
  RuntimeLoadedData? get loadedData => _instance?._loadedData;
  Lock get lock => _instance?._lock ?? false;
  set lock(l) => _instance?._lock = l;
  Lock _lock = false;

  set updateLoadedData(RuntimeLoadedData lD) {
    _loadedData = lD;
    log(
      name: 'update_local_runtime_data',
      lD.toString(),
    );
  }

  RuntimeLoadedDataSingleton._internal(this._loadedData);

  factory RuntimeLoadedDataSingleton(RuntimeLoadedData? _loadedData) {
    _instance ??= RuntimeLoadedDataSingleton._internal(_loadedData);
    return _instance!;
  }

  bool isLoaded() => _instance?._loadedData != null;
}
