import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../l10n/strings.dart';

/// يدير اللغة المختارة مع الحفظ. الإنجليزية هي الافتراضية.
class LocaleProvider extends ChangeNotifier {
  static const _kKey = 'app_language';
  static const _fallback = 'en';

  String _code = _fallback;

  String get code => _code;
  Locale get locale => Locale(_code);
  Strings get strings => Strings(_code);

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_kKey);
    if (saved != null && Strings.languageNames.containsKey(saved)) {
      _code = saved;
    }
    notifyListeners();
  }

  Future<void> setLanguage(String code) async {
    if (!Strings.languageNames.containsKey(code) || code == _code) return;
    _code = code;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kKey, code);
  }
}

/// اختصار للوصول للترجمات: `context.s.add`
extension StringsX on BuildContext {
  Strings get s => Strings(
        // ignore: use_build_context_synchronously
        Localizations.localeOf(this).languageCode,
      );
}
