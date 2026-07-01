/// كاس مفضّل: كمية + نوع المشروب، باش يزيدو المستخدم بسرعة.
class Favorite {
  final int amount;
  final String drinkId;

  const Favorite({required this.amount, this.drinkId = 'water'});

  Map<String, dynamic> toJson() => {'amount': amount, 'drinkId': drinkId};

  factory Favorite.fromJson(Map<String, dynamic> json) => Favorite(
        amount: json['amount'] as int,
        drinkId: (json['drinkId'] as String?) ?? 'water',
      );

  /// المفضّلات الافتراضية فأول تشغيل.
  static const List<Favorite> defaults = [
    Favorite(amount: 150, drinkId: 'water'),
    Favorite(amount: 200, drinkId: 'water'),
    Favorite(amount: 330, drinkId: 'water'),
    Favorite(amount: 500, drinkId: 'water'),
  ];

  @override
  bool operator ==(Object other) =>
      other is Favorite &&
      other.amount == amount &&
      other.drinkId == drinkId;

  @override
  int get hashCode => Object.hash(amount, drinkId);
}
