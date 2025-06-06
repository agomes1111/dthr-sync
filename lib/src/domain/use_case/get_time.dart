import 'package:dthr_sync/src/data/repo/data_repo.dart';
import 'package:dthr_sync/src/domain/entities/runtime_data.dart';

class GetTimeUseCase {
  DataRepo _dataRepo;

  GetTimeUseCase(this._dataRepo);

  Future<RuntimeData> call() async {
    return (await _dataRepo.getData()).fold(
      (l) => l,
      (r) => r.toRuntimeData(_dataRepo.apiSource.settings),
    );
  }
}
