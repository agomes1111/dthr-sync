import 'dart:convert';
import 'dart:developer';

import 'package:dthr_sync/src/data/dto/api_time_dto.dart';
import 'package:dthr_sync/src/domain/entities/plugin_settings.dart';
import 'package:http/http.dart' as http;

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

  Future<ApiTimeDto> getSvTimeStamp() async {
    final start = DateTime.now();
    Uri url = Uri.parse(settings.api_url);
    log(name: 'fetching_timestamp_from_${url.toString()}', '');
    final response = await http.get(url);
    // if(response)
    final latency = DateTime.now().difference(start) ~/ 2;

    if (response.statusCode == 200) {
      // final serverTime = DateTime.parse(json.decode(response.body)['dthr']);
      // _adjustedDthr = serverTime.add(latency);
      // _localSyncTime = DateTime.now();
      // await _persist(_adjustedDthr!, _localSyncTime!);
      return ApiTimeDto(
        serverTimestamp: DateTime.parse(json.decode(response.body)['dthr']),
        networkLatency: latency,
      );
    }
    throw 'error_fetching_sv_timesatamp_http_${response.statusCode}';
  }
}
