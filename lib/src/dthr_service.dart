import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DthrService {
  static const _adjustedKey = 'adjustedDthr';
  static const _syncKey = 'localSyncTime';

  final String apiUrl;
  Duration _pollInterval;
  DateTime? _adjustedDthr;
  DateTime? _localSyncTime;
  Timer? _syncTimer;

  DthrService(this.apiUrl,
      {Duration pollInterval = const Duration(minutes: 10)})
      : _pollInterval = pollInterval;

  Future<void> initialize() async {
    final restored = await _restore();
    if (restored == null) {
      await _syncWithApi();
    } else {
      _adjustedDthr = restored.$1;
      _localSyncTime = restored.$2;
    }
    _startPeriodicSync();
  }

  Future<DateTime?> getCurrentDthr() async {
    if (_adjustedDthr == null || _localSyncTime == null) return null;
    final elapsed = DateTime.now().difference(_localSyncTime!);
    return _adjustedDthr!.add(elapsed);
  }

  void _startPeriodicSync() {
    _syncTimer?.cancel();
    _syncTimer = Timer.periodic(_pollInterval, (_) => _syncWithApi());
  }

  Future<void> _syncWithApi() async {
    try {
      final start = DateTime.now();
      final response = await http.get(Uri.parse(apiUrl));
      final latency = DateTime.now().difference(start) ~/ 2;

      if (response.statusCode == 200) {
        final serverTime = DateTime.parse(json.decode(response.body)['dthr']);
        _adjustedDthr = serverTime.add(latency);
        _localSyncTime = DateTime.now();
        await _persist(_adjustedDthr!, _localSyncTime!);
      }
    } catch (e) {
      if (kDebugMode) print('Erro ao sincronizar DTHR: $e');
    }
  }

  Future<void> _persist(DateTime adjusted, DateTime syncTime) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_adjustedKey, adjusted.toIso8601String());
    await prefs.setString(_syncKey, syncTime.toIso8601String());
  }

  Future<(DateTime, DateTime)?> _restore() async {
    final prefs = await SharedPreferences.getInstance();
    final adj = prefs.getString(_adjustedKey);
    final sync = prefs.getString(_syncKey);
    if (adj == null || sync == null) return null;
    return (DateTime.parse(adj), DateTime.parse(sync));
  }

  void dispose() {
    _syncTimer?.cancel();
  }
}
