import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/water_entry.dart';
import '../models/favorite.dart';

/// مزوّد الحالة: يدير سجلات الشرب، الهدف، المفضّلات، والإحصائيات.
class WaterProvider extends ChangeNotifier {
  static const _kLogsKey = 'water_logs';
  static const _kGoalKey = 'daily_goal';
  static const _kFavKey = 'favorites';

  final Map<String, DayLog> _logs = {};
  List<Favorite> _favorites = List.of(Favorite.defaults);
  int _dailyGoal = 2000;
  bool _loaded = false;

  int get dailyGoal => _dailyGoal;
  bool get loaded => _loaded;
  List<Favorite> get favorites => List.unmodifiable(_favorites);

  String _keyFor(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  String get _todayKey => _keyFor(DateTime.now());

  int get todayTotal => _logs[_todayKey]?.total ?? 0;

  double get progress =>
      _dailyGoal == 0 ? 0 : (todayTotal / _dailyGoal).clamp(0.0, 1.0);

  bool get goalReached => todayTotal >= _dailyGoal;

  int get remaining => (_dailyGoal - todayTotal).clamp(0, _dailyGoal);

  /// عدد الكؤوس اليوم.
  int get todayCount => _logs[_todayKey]?.entries.length ?? 0;

  List<WaterEntry> get todayEntries {
    final list = List<WaterEntry>.from(_logs[_todayKey]?.entries ?? []);
    list.sort((a, b) => b.time.compareTo(a.time));
    return list;
  }

  List<MapEntry<DateTime, int>> lastDays(int days) {
    final now = DateTime.now();
    final result = <MapEntry<DateTime, int>>[];
    for (int i = days - 1; i >= 0; i--) {
      final d = DateTime(now.year, now.month, now.day - i);
      result.add(MapEntry(d, _logs[_keyFor(d)]?.total ?? 0));
    }
    return result;
  }

  int _totalFor(DateTime d) => _logs[_keyFor(d)]?.total ?? 0;

  /// سلسلة الأيام المتتالية اللي كملتي فيها الهدف (تحسب اليوم إلا تكمّل).
  int get streak {
    final now = DateTime.now();
    int count = 0;
    // إلا اليوم متكمّلش، نبداو من البارح.
    int startOffset = goalReached ? 0 : 1;
    for (int i = startOffset;; i++) {
      final d = DateTime(now.year, now.month, now.day - i);
      if (_totalFor(d) >= _dailyGoal && _dailyGoal > 0) {
        count++;
      } else {
        break;
      }
    }
    return count;
  }

  /// مجموع كل الما اللي تشرب فحياة التطبيق (بالمليلتر).
  int get lifetimeTotal =>
      _logs.values.fold(0, (sum, log) => sum + log.total);

  /// عدد الأيام اللي تسجّل فيها شي حاجة.
  int get daysTracked => _logs.values.where((l) => l.total > 0).length;

  /// أكبر كمية فيوم واحد.
  int get bestDay =>
      _logs.values.fold(0, (m, l) => l.total > m ? l.total : m);

  /// عدد الأيام اللي تكمّل فيها الهدف.
  int get goalsHitTotal =>
      _logs.values.where((l) => l.total >= _dailyGoal).length;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _dailyGoal = prefs.getInt(_kGoalKey) ?? 2000;

    final raw = prefs.getString(_kLogsKey);
    if (raw != null && raw.isNotEmpty) {
      try {
        final decoded = jsonDecode(raw) as Map<String, dynamic>;
        decoded.forEach((key, value) {
          _logs[key] = DayLog.fromJson(value as Map<String, dynamic>);
        });
      } catch (_) {}
    }

    final favRaw = prefs.getString(_kFavKey);
    if (favRaw != null && favRaw.isNotEmpty) {
      try {
        final list = jsonDecode(favRaw) as List;
        _favorites = list
            .map((e) => Favorite.fromJson(e as Map<String, dynamic>))
            .toList();
      } catch (_) {}
    }

    _loaded = true;
    notifyListeners();
  }

  Future<void> _persistLogs() async {
    final prefs = await SharedPreferences.getInstance();
    final map = _logs.map((k, v) => MapEntry(k, v.toJson()));
    await prefs.setString(_kLogsKey, jsonEncode(map));
    await prefs.setInt(_kGoalKey, _dailyGoal);
  }

  Future<void> _persistFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        _kFavKey, jsonEncode(_favorites.map((f) => f.toJson()).toList()));
  }

  /// إضافة كمية، يرجع true إلا هاد الإضافة هي اللي كمّلات الهدف.
  Future<bool> addWater(int amount, {String drinkId = 'water'}) async {
    if (amount <= 0) return false;
    final wasReached = goalReached;
    final key = _todayKey;
    final log = _logs.putIfAbsent(key, () => DayLog(dateKey: key, entries: []));
    log.entries
        .add(WaterEntry(amount: amount, time: DateTime.now(), drinkId: drinkId));
    notifyListeners();
    await _persistLogs();
    return !wasReached && goalReached;
  }

  Future<void> removeEntry(WaterEntry entry) async {
    final log = _logs[_todayKey];
    if (log == null) return;
    log.entries.remove(entry);
    if (log.entries.isEmpty) _logs.remove(_todayKey);
    notifyListeners();
    await _persistLogs();
  }

  Future<void> undoLast() async {
    final entries = _logs[_todayKey]?.entries;
    if (entries == null || entries.isEmpty) return;
    entries.removeLast();
    if (entries.isEmpty) _logs.remove(_todayKey);
    notifyListeners();
    await _persistLogs();
  }

  Future<void> setGoal(int goal) async {
    _dailyGoal = goal.clamp(200, 10000);
    notifyListeners();
    await _persistLogs();
  }

  // ---- المفضّلات ----

  Future<void> addFavorite(Favorite fav) async {
    if (_favorites.contains(fav)) return;
    _favorites.add(fav);
    _favorites.sort((a, b) => a.amount.compareTo(b.amount));
    notifyListeners();
    await _persistFavorites();
  }

  Future<void> removeFavorite(Favorite fav) async {
    _favorites.remove(fav);
    notifyListeners();
    await _persistFavorites();
  }
}
