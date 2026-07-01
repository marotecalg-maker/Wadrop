import 'package:flutter/material.dart';

/// نوع المشروب (ما، قهوة، أتاي...) مع لونه وإيموجي وعامل الترطيب.
class DrinkType {
  final String id;
  final String name; // بالعربية
  final String emoji;
  final Color color;
  final double hydration; // كم نسبة الماء فيه (1.0 = ما صافي)

  const DrinkType({
    required this.id,
    required this.name,
    required this.emoji,
    required this.color,
    this.hydration = 1.0,
  });

  /// كل الأنواع المتاحة.
  static const List<DrinkType> all = [
    DrinkType(id: 'water', name: 'ما', emoji: '💧', color: Color(0xFF0288D1)),
    DrinkType(
        id: 'coffee',
        name: 'قهوة',
        emoji: '☕',
        color: Color(0xFF795548),
        hydration: 0.8),
    DrinkType(
        id: 'tea',
        name: 'أتاي',
        emoji: '🍵',
        color: Color(0xFF43A047),
        hydration: 0.9),
    DrinkType(
        id: 'juice',
        name: 'عصير',
        emoji: '🧃',
        color: Color(0xFFFB8C00),
        hydration: 0.85),
    DrinkType(
        id: 'milk',
        name: 'حليب',
        emoji: '🥛',
        color: Color(0xFF90A4AE),
        hydration: 0.9),
    DrinkType(
        id: 'soda',
        name: 'مشروب غازي',
        emoji: '🥤',
        color: Color(0xFFE53935),
        hydration: 0.6),
  ];

  static DrinkType byId(String id) =>
      all.firstWhere((d) => d.id == id, orElse: () => all.first);
}
