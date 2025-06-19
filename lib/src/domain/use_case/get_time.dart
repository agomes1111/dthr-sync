import 'package:dthr_sync/src/data/repo/data_repo.dart';
import 'package:dthr_sync/src/domain/entities/runtime_data.dart';

class GetTimeUseCase {
  DataRepo _dataRepo;
  GetTimeUseCase(this._dataRepo);

  Future<RuntimeData> call(String id) async {
    return (await _dataRepo.getDataById(id)).fold(
      /// returns runtime loaded timestamp
      (l) => l,

      /// returns api fetched timestamp
      (r) => r.toRuntimeData(_dataRepo.apiSource!.settings),
    );
  }
}
