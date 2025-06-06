import 'package:dthr_sync/src/data/service/sync_service.dart';
import 'package:dthr_sync/src/domain/entities/runtime_data.dart';

class SyncUseCase {
  SyncService syncService;
  SyncUseCase(this.syncService);

  Future call(RuntimeData args) async {
    await syncService.syncStoredData(args);
  }
}
