import 'package:dthr_sync/dthr_sync.dart';
import 'package:dthr_sync/src/data/dto/api_time_dto.dart';
import 'package:dthr_sync/src/data/dto/runtime_loaded_data.dart';
import 'package:dthr_sync/src/data/source/api_source.dart';
import 'package:dthr_sync/src/data/source/cache.dart';
import 'package:dthr_sync/src/data/source/runtime_loaded_data_singleton.dart';
import 'package:dthr_sync/src/domain/repo/data_repo.dart';
import 'package:either_dart/either.dart';

class DataRepo implements DataRepository {
  @override
  ApiSource apiSource;
  @override
  Cache cache;
  @override
  RuntimeLoadedDataSingleton loadedDataSingleton;

  DataRepo({
    required this.apiSource,
    required this.cache,
    required this.loadedDataSingleton,
  });

  @override
  Future<Either<RuntimeLoadedData, ApiTimeDto>> getData() async {
    if (loadedDataSingleton.isLoaded()) {
      /// if there is already any loaded data: returns it
      return Left(loadedDataSingleton.loadedData!);
    } else {
      /// if there is not any data loaded fetchs from API
      ApiTimeDto _apiTime = await apiSource.getApiTimeMock();
      return Right(_apiTime);
    }
  }
}
