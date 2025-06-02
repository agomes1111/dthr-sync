import 'package:dthr_sync/src/data/dto/runtime_loaded_data.dart';

class RuntimeLoadedDataSingleton {
  static RuntimeLoadedDataSingleton? _instance;

  /// nullable so plugin can load without any loaded data
  final RuntimeLoadedData? loadedData;

  RuntimeLoadedDataSingleton._internal(this.loadedData);

  factory RuntimeLoadedDataSingleton(RuntimeLoadedData? loadedData) {
    _instance ??= RuntimeLoadedDataSingleton._internal(loadedData);
    return _instance!;
  }

  bool isLoaded() => loadedData != null;
}
