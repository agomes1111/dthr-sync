import 'dart:developer';

import 'package:dthr_sync/src/data/service/sync_service.dart';

class SyncUseCase {
  SyncService syncService;
  SyncUseCase(this.syncService) {
    log(
      name: 'sync_started_device_timestamp',
      DateTime.now().toString(),
    );
  }
}
