import 'package:dthr_sync/src/data/dto/api_time_dto.dart';
import 'package:dthr_sync/src/domain/entities/plugin_settings.dart';

class ApiSource {
  PluginSettings settings;
  ApiSource(this.settings);

  Future<ApiTimeDto> getApiTimeThrow() async {
    throw Exception('test');
  }

  Future<ApiTimeDto> getApiTimeMock() async {
    await Future.delayed(const Duration(seconds: 1));
    return ApiTimeDto(
      serverTimestamp: DateTime.now(),
      networkLatency: const Duration(seconds: 1),
    );
  }
}
