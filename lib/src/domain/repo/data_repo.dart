import 'package:dthr_sync/src/data/dto/api_time_dto.dart';
import 'package:dthr_sync/src/data/source/api_source.dart';
import 'package:dthr_sync/src/data/source/cache.dart';
import 'package:dthr_sync/src/data/source/runtime_loaded_data_singleton.dart';
import 'package:dthr_sync/src/domain/entities/runtime_data.dart';
import 'package:either_dart/either.dart';

abstract class DataRepository {
  ApiSource? apiSource;
  Cache cache;
  RuntimeLoadedDataSingleton loadedDataSingleton;

  DataRepository({
    required this.apiSource,
    required this.cache,
    required this.loadedDataSingleton,
  });

  Future<Either<RuntimeData, ApiTimeDto>> getDataById(String id);
}
