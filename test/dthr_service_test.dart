import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:dthr_sync/src/dthr_service.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mockito/annotations.dart';

import 'dthr_service_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  late MockClient mockHttp;
  late DateTime serverNow;
  late DthrService clock;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    mockHttp = MockClient();
    serverNow = DateTime.utc(2025, 05, 21, 12, 00, 00);

    clock = DthrService('http://127.0.0.1:8080/api/dthr');
    clock.apiUrl;
  });

  test('Sincroniza corretamente com a API e persiste dados', () async {
    final fakeResponse = jsonEncode({'dthr': serverNow.toIso8601String()});
    when(mockHttp.get(any))
        .thenAnswer((_) async => http.Response(fakeResponse, 200));

    await clock.initialize();

    final current = await clock.getCurrentDthr();
    expect(current, isNotNull);
    expect(current!.difference(serverNow).inSeconds, lessThan(3));
  });

  test('Restaura DTHR do cache local quando offline', () async {
    final adjusted = serverNow.add(const Duration(milliseconds: 500));
    final syncTime = DateTime.now();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('adjustedDthr', adjusted.toIso8601String());
    await prefs.setString('localSyncTime', syncTime.toIso8601String());

    await clock.initialize();
    final now = await clock.getCurrentDthr();
    final diff = now!
        .difference(adjusted.add(DateTime.now().difference(syncTime)))
        .inSeconds;
    expect(diff.abs(), lessThanOrEqualTo(1));
  });

  test('Não falha se a API estiver indisponível', () async {
    when(mockHttp.get(any)).thenThrow(Exception('API down'));

    await clock.initialize();
    final now = await clock.getCurrentDthr();
    expect(now, isNotNull);
  });
}
