import 'dart:developer';

import 'package:dthr_sync/src/data/dto/runtime_loaded_data.dart';
import 'package:dthr_sync/src/domain/entities/runtime_data.dart';
import 'package:collection/collection.dart';

typedef Lock = bool;

class RuntimeLoadedDataSingleton {
  static RuntimeLoadedDataSingleton? _instance;

  /// nullable so plugin can load without any loaded data
  RuntimeLoadedData? _loadedData;
  RuntimeLoadedData? get loadedData => _instance?._loadedData;
  set loadedData(RuntimeLoadedData? runtimeLoadedData) =>
      _instance?._loadedData = runtimeLoadedData;
  Lock get lock => _instance?._lock ?? false;
  set lock(l) => _instance?._lock = l;
  Lock _lock = false;

  set updateLoadedData(RuntimeData runtimeData) {
    _instance?._loadedData?.runtimeLoadedData.firstWhereOrNull(
      (i) => i.id == runtimeData.id,
    );
    log(
      name: 'update_local_runtime_data',
      runtimeData.toString(),
    );

    int index =
        _instance?._loadedData?.runtimeLoadedData.indexWhere((i) => i.id == runtimeData.id) ?? -1;

    if (index != -1) {
      _instance?._loadedData?.runtimeLoadedData[index] = runtimeData as SingleRuntimeData;
      log(
        name: 'update_local_runtime_data',
        runtimeData.toString(),
      );
    } else {
      log(
        name: '[err]update_local_runtime_data',
        'returned_index_${index}_for: ' + runtimeData.toString(),
      );
    }
  }

  RuntimeLoadedDataSingleton._internal(this._loadedData);

  factory RuntimeLoadedDataSingleton(RuntimeLoadedData? _loadedData) {
    _instance ??= RuntimeLoadedDataSingleton._internal(_loadedData);
    log(
      name: 'creating_runtime_data_singleton_hashcode:',
      _instance.hashCode.toString(),
    );
    return _instance!;
  }

  bool isLoaded() => _instance?._loadedData != null;
}
