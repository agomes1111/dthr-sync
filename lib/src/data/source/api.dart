import 'package:dthr_sync/src/data/dto/api_time_dto.dart';
import 'package:dthr_sync/src/domain/entities/plugin_settings.dart';

class ApiSource {
  PluginSettings settings;
  ApiSource(this.settings);

  Future<ApiTimeDto> getApiTimeMock() async {
    await Future.delayed(Duration(seconds: 2));
    // return DateTime.now();
    return ApiTimeDto(
      serverTimestamp: DateTime.now(),
      networkLatency: const Duration(seconds: 1),
    );
  }
}
