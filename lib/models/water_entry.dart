/// نموذج يمثّل عملية شرب واحدة (الكمية بالمليلتر + الوقت + نوع المشروب).
class WaterEntry {
  final int amount; // بالمليلتر (ml)
  final DateTime time;
  final String drinkId; // معرّف نوع المشروب (water, coffee...)

  WaterEntry({
    required this.amount,
    required this.time,
    this.drinkId = 'water',
  });

  Map<String, dynamic> toJson() => {
        'amount': amount,
        'time': time.toIso8601String(),
        'drinkId': drinkId,
      };

  factory WaterEntry.fromJson(Map<String, dynamic> json) => WaterEntry(
        amount: json['amount'] as int,
        time: DateTime.parse(json['time'] as String),
        // البيانات القديمة ماكانش فيها drinkId.
        drinkId: (json['drinkId'] as String?) ?? 'water',
      );
}

/// يجمع كل ما تم شربه في يوم واحد.
class DayLog {
  final String dateKey; // صيغة yyyy-MM-dd
  final List<WaterEntry> entries;

  DayLog({required this.dateKey, required this.entries});

  int get total => entries.fold(0, (sum, e) => sum + e.amount);

  Map<String, dynamic> toJson() => {
        'dateKey': dateKey,
        'entries': entries.map((e) => e.toJson()).toList(),
      };

  factory DayLog.fromJson(Map<String, dynamic> json) => DayLog(
        dateKey: json['dateKey'] as String,
        entries: (json['entries'] as List)
            .map((e) => WaterEntry.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}
