import 'package:flutter/material.dart';

/// نظام ترجمة بسيط يدعم 3 لغات: الإنجليزية (رئيسية)، العربية، الفرنسية.
/// كل مفتاح فيه [en, ar, fr] بهاد الترتيب.
class Strings {
  final String code;
  const Strings(this.code);

  /// اللغات المدعومة. الإنجليزية هي الرئيسية (الأولى).
  static const List<Locale> supportedLocales = [
    Locale('en'),
    Locale('ar'),
    Locale('fr'),
  ];

  static const Map<String, String> languageNames = {
    'en': 'English',
    'ar': 'العربية',
    'fr': 'Français',
  };

  bool get isRtl => code == 'ar';

  int get _i => switch (code) {
        'ar' => 1,
        'fr' => 2,
        _ => 0,
      };

  String _g(String key) {
    final v = _data[key];
    if (v == null) return key;
    return _i < v.length ? v[_i] : v[0];
  }

  // ---- نصوص بسيطة ----
  String get appTitle => _g('appTitle');
  String get nightMode => _g('nightMode');
  String get achievements => _g('achievements');
  String get statistics => _g('statistics');
  String get settings => _g('settings');
  String get favorites => _g('favorites');
  String get addDrink => _g('addDrink');
  String get undo => _g('undo');
  String get dayStreak => _g('dayStreak');
  String get cupsToday => _g('cupsToday');
  String get ofGoal => _g('ofGoal');
  String get goalReachedBanner => _g('goalReachedBanner');
  String get addToFavorites => _g('addToFavorites');
  String get noFavorites => _g('noFavorites');
  String get ml => _g('ml');
  String get todayLog => _g('todayLog');
  String get emptyToday => _g('emptyToday');
  String get removeFavoriteTitle => _g('removeFavoriteTitle');
  String get cancel => _g('cancel');
  String get delete => _g('delete');
  String get addNewFavorite => _g('addNewFavorite');
  String get drinkType => _g('drinkType');
  String get amountMl => _g('amountMl');
  String get saveFavorite => _g('saveFavorite');
  String get add => _g('add');
  String get dailyGoal => _g('dailyGoal');
  String get appearance => _g('appearance');
  String get light => _g('light');
  String get dark => _g('dark');
  String get system => _g('system');
  String get language => _g('language');
  String get tip => _g('tip');
  String get average => _g('average');
  String get goalDaysHit => _g('goalDaysHit');
  String get last7Days => _g('last7Days');
  String get legendNormal => _g('legendNormal');
  String get legendGoal => _g('legendGoal');
  String get streak => _g('streak');
  String get total => _g('total');
  String get goals => _g('goals');

  // ---- نصوص بمتغيّرات ----
  String remainingToGoal(int ml) =>
      _g('remainingToGoal').replaceAll('{ml}', '$ml');
  String entryTitle(int amount, String drink) =>
      _g('entryTitle').replaceAll('{amount}', '$amount').replaceAll('{drink}', drink);
  String atTime(String time) => _g('atTime').replaceAll('{time}', time);
  String addedSnack(int amount, String emoji) =>
      _g('addedSnack').replaceAll('{amount}', '$amount').replaceAll('{emoji}', emoji);
  String mlPerDay(int goal) => _g('mlPerDay').replaceAll('{goal}', '$goal');
  String mlValue(int v) => _g('mlValue').replaceAll('{v}', '$v');
  String badgesCount(int n, int total) =>
      _g('badgesCount').replaceAll('{n}', '$n').replaceAll('{total}', '$total');
  String litersShort(String v) => _g('litersShort').replaceAll('{v}', v);
  String mlWithUnit(int v) => '$v $ml';

  /// اسم المشروب حسب اللغة.
  String drinkName(String id) => _g('drink_$id');

  /// رموز أيام الأسبوع (مرتّبة من الأحد). weekday % 7 → 0=الأحد.
  List<String> get dayNames => switch (code) {
        'ar' => const ['ح', 'ن', 'ث', 'ر', 'خ', 'ج', 'س'],
        'fr' => const ['Di', 'Lu', 'Ma', 'Me', 'Je', 'Ve', 'Sa'],
        _ => const ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'],
      };

  /// عناوين/أوصاف الشارات (id → [title, desc]).
  (String, String) badge(String id) {
    final t = _data['badge_${id}_t']!;
    final d = _data['badge_${id}_d']!;
    return (_i < t.length ? t[_i] : t[0], _i < d.length ? d[_i] : d[0]);
  }

  // [en, ar, fr]
  static const Map<String, List<String>> _data = {
    'appTitle': [
      'Wadrop 💧',
      'Wadrop 💧',
      'Wadrop 💧',
    ],
    'nightMode': ['Night mode', 'الوضع الليلي', 'Mode nuit'],
    'achievements': ['Achievements', 'الإنجازات', 'Réalisations'],
    'statistics': ['Statistics', 'الإحصائيات', 'Statistiques'],
    'settings': ['Settings', 'الإعدادات', 'Paramètres'],
    'favorites': ['Favorites 🥤', 'المفضّلات 🥤', 'Favoris 🥤'],
    'addDrink': ['Add drink', 'زيد مشروب', 'Ajouter'],
    'undo': ['Undo', 'تراجع', 'Annuler'],
    'dayStreak': ['day streak', 'يوم متتالي', 'jours de suite'],
    'cupsToday': ['cups today', 'كاس اليوم', 'verres'],
    'ofGoal': ['of goal', 'من الهدف', "de l'objectif"],
    'goalReachedBanner': [
      'Bravo! You reached your goal today 🎉',
      'برافو! كملتي الهدف ديالك اليوم 🎉',
      "Bravo ! Objectif atteint aujourd'hui 🎉",
    ],
    'remainingToGoal': [
      '{ml} ml left to reach your goal',
      'باقي ليك {ml} مل باش توصل للهدف',
      "Il reste {ml} ml pour atteindre l'objectif",
    ],
    'addToFavorites': ['Add to favorites', 'زيد للمفضّلة', 'Ajouter aux favoris'],
    'noFavorites': [
      'You have no favorites 🙂 Add one with the + button',
      'ما عندك حتى مفضّلة 🙂 زيد وحدة بالزر +',
      'Aucun favori 🙂 Ajoutez-en un avec le bouton +',
    ],
    'ml': ['ml', 'مل', 'ml'],
    'todayLog': ["Today's log 📋", 'سجل اليوم 📋', "Journal du jour 📋"],
    'emptyToday': [
      "You haven't drunk anything yet today 🙂\nStart with a glass of water!",
      'مازال ما شربتي والو اليوم 🙂\nبدا بكاس ما!',
      "Vous n'avez encore rien bu aujourd'hui 🙂\nCommencez par un verre d'eau !",
    ],
    'entryTitle': ['{amount} ml · {drink}', '{amount} مل · {drink}', '{amount} ml · {drink}'],
    'atTime': ['at {time}', 'فالساعة {time}', 'à {time}'],
    'addedSnack': [
      'Added {amount} ml {emoji}',
      'زدنا {amount} مل {emoji}',
      '{amount} ml ajoutés {emoji}',
    ],
    'removeFavoriteTitle': ['Remove favorite?', 'تمسح المفضّلة؟', 'Supprimer le favori ?'],
    'cancel': ['Cancel', 'إلغاء', 'Annuler'],
    'delete': ['Delete', 'مسح', 'Supprimer'],
    'addNewFavorite': ['Add new favorite', 'زيد مفضّلة جديدة', 'Nouveau favori'],
    'drinkType': ['Drink type', 'نوع المشروب', 'Type de boisson'],
    'amountMl': ['Amount (ml)', 'الكمية (مل)', 'Quantité (ml)'],
    'saveFavorite': ['Save favorite', 'حفظ المفضّلة', 'Enregistrer'],
    'add': ['Add', 'زيد', 'Ajouter'],
    'dailyGoal': ['Daily goal', 'الهدف اليومي', 'Objectif quotidien'],
    'mlPerDay': ['{goal} ml per day', '{goal} مل فاليوم', '{goal} ml par jour'],
    'appearance': ['Appearance', 'المظهر', 'Apparence'],
    'light': ['Light ☀️', 'فاتح ☀️', 'Clair ☀️'],
    'dark': ['Dark 🌙', 'داكن 🌙', 'Sombre 🌙'],
    'system': ['System 📱', 'حسب النظام 📱', 'Système 📱'],
    'language': ['Language', 'اللغة', 'Langue'],
    'tip': [
      'Tip: An average person should drink between 2 and 3 liters of water per day 💧',
      'نصيحة: الإنسان العادي خاصو يشرب ما بين 2 و 3 لتر ديال الما فاليوم 💧',
      'Astuce : une personne moyenne devrait boire entre 2 et 3 litres d\'eau par jour 💧',
    ],
    'average': ['Average', 'المعدّل', 'Moyenne'],
    'mlValue': ['{v} ml', '{v} مل', '{v} ml'],
    'goalDaysHit': ['Days goal hit', 'أيام كملتي الهدف', 'Jours objectif atteint'],
    'last7Days': ['Last 7 days', 'آخر 7 أيام', '7 derniers jours'],
    'legendNormal': ['Normal', 'عادي', 'Normal'],
    'legendGoal': ['Goal reached', 'كملتي الهدف', 'Objectif atteint'],
    'streak': ['Streak', 'سلسلة', 'Série'],
    'total': ['Total', 'المجموع', 'Total'],
    'goals': ['Goals', 'أهداف', 'Objectifs'],
    'badgesCount': ['{n} / {total} badges', '{n} / {total} شارة', '{n} / {total} badges'],
    'litersShort': ['{v}L', '{v}ل', '{v}L'],

    // ---- المشروبات ----
    'drink_water': ['Water', 'ما', 'Eau'],
    'drink_coffee': ['Coffee', 'قهوة', 'Café'],
    'drink_tea': ['Tea', 'أتاي', 'Thé'],
    'drink_juice': ['Juice', 'عصير', 'Jus'],
    'drink_milk': ['Milk', 'حليب', 'Lait'],
    'drink_soda': ['Soda', 'مشروب غازي', 'Soda'],

    // ---- الشارات (badges) ----
    'badge_first_t': ['First drop', 'أول قطرة', 'Première goutte'],
    'badge_first_d': ['Log your first drink', 'سجّل أول مشروب', 'Enregistrez votre première boisson'],
    'badge_streak3_t': ['3-day streak', 'سلسلة 3 أيام', 'Série de 3 jours'],
    'badge_streak3_d': ['3 days in a row at goal', '3 أيام متتالية فالهدف', '3 jours de suite à l\'objectif'],
    'badge_streak7_t': ['7-day streak', 'سلسلة 7 أيام', 'Série de 7 jours'],
    'badge_streak7_d': ['A full week at goal', 'أسبوع كامل فالهدف', 'Une semaine entière à l\'objectif'],
    'badge_goal1_t': ['Goal reached', 'هدف مكمّل', 'Objectif atteint'],
    'badge_goal1_d': ['Reach your goal once', 'كمّل الهدف ولو مرة', 'Atteignez l\'objectif au moins une fois'],
    'badge_goal10_t': ['10 goals', '10 أهداف', '10 objectifs'],
    'badge_goal10_d': ['Reach your goal 10 times', 'كمّل الهدف 10 مرات', 'Atteignez l\'objectif 10 fois'],
    'badge_liters10_t': ['10 liters', '10 لتر', '10 litres'],
    'badge_liters10_d': ['Drink 10 liters total', 'اشرب 10 لتر بالمجموع', 'Buvez 10 litres au total'],
    'badge_liters50_t': ['50 liters', '50 لتر', '50 litres'],
    'badge_liters50_d': ['Drink 50 liters total', 'اشرب 50 لتر بالمجموع', 'Buvez 50 litres au total'],
    'badge_days7_t': ['7 days tracked', '7 أيام تتبّع', '7 jours suivis'],
    'badge_days7_d': ['Log on 7 different days', 'سجّل ف7 أيام مختلفة', 'Enregistrez sur 7 jours différents'],
  };
}
