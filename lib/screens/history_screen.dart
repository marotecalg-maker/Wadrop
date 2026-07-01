import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/water_provider.dart';
import '../providers/locale_provider.dart';
import '../theme/app_theme.dart';

/// شاشة إحصائيات آخر 7 أيام برسم بياني بسيط.
class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final dayNames = s.dayNames;
    return Scaffold(
      appBar: AppBar(title: Text('${s.statistics} 📊')),
      body: Consumer<WaterProvider>(
        builder: (context, water, _) {
          final days = water.lastDays(7);
          final goal = water.dailyGoal;
          final maxVal = days
              .map((e) => e.value)
              .fold<int>(goal, (m, v) => v > m ? v : m)
              .toDouble();
          final avg = days.isEmpty
              ? 0
              : (days.fold<int>(0, (s, e) => s + e.value) / days.length)
                  .round();
          final goalsHit = days.where((e) => e.value >= goal).length;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    _statCard(context, s.average, s.mlValue(avg),
                        Icons.show_chart_rounded, AppTheme.accent(context)),
                    const SizedBox(width: 12),
                    _statCard(context, s.goalDaysHit, '$goalsHit / 7',
                        Icons.emoji_events_rounded, Colors.orange),
                  ],
                ),
                const SizedBox(height: 28),
                Text(s.last7Days,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                Container(
                  height: 230,
                  padding: const EdgeInsets.fromLTRB(8, 16, 8, 8),
                  decoration: BoxDecoration(
                    color: AppTheme.card(context),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppTheme.border(context)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: days.map((entry) {
                      final ratio = maxVal == 0 ? 0.0 : entry.value / maxVal;
                      final reached = entry.value >= goal;
                      return Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              entry.value == 0 ? '' : '${entry.value}',
                              style: TextStyle(
                                  fontSize: 9,
                                  color: AppTheme.softText(context)),
                            ),
                            const SizedBox(height: 4),
                            Expanded(
                              child: FractionallySizedBox(
                                alignment: Alignment.bottomCenter,
                                heightFactor: ratio == 0 ? 0.01 : ratio,
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 5),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: reached
                                          ? [
                                              const Color(0xFF66BB6A),
                                              const Color(0xFF43A047)
                                            ]
                                          : [
                                              const Color(0xFF4FC3F7),
                                              const Color(0xFF0288D1)
                                            ],
                                    ),
                                    borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(6)),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(dayNames[entry.key.weekday % 7],
                                style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _legend(const Color(0xFF0288D1), s.legendNormal),
                    const SizedBox(width: 20),
                    _legend(const Color(0xFF43A047), s.legendGoal),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _statCard(BuildContext context, String title, String value,
      IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.card(context),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppTheme.border(context)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(value,
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(title,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 12, color: AppTheme.softText(context))),
          ],
        ),
      ),
    );
  }

  Widget _legend(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
              color: color, borderRadius: BorderRadius.circular(4)),
        ),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 13)),
      ],
    );
  }
}
