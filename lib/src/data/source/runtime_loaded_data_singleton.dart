import 'package:dthr_sync/src/data/dto/runtime_loaded_data.dart';

class RuntimeLoadedDataSingleton {
  static RuntimeLoadedDataSingleton? _instance;

  /// nullable so plugin can load without any loaded data
  RuntimeLoadedData? _loadedData;
  RuntimeLoadedData? get loadedData => _loadedData;
  set updateLoadedData(RuntimeLoadedData lD) => _loadedData = lD;

  RuntimeLoadedDataSingleton._internal(this._loadedData);

  factory RuntimeLoadedDataSingleton(RuntimeLoadedData? _loadedData) {
    _instance ??= RuntimeLoadedDataSingleton._internal(_loadedData);
    return _instance!;
  }

  bool isLoaded() => _loadedData != null;
}
