import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/water_provider.dart';
import '../providers/locale_provider.dart';
import '../theme/app_theme.dart';

/// شاشة الإنجازات: شارات (badges) كتفتح حسب التقدّم.
class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    return Scaffold(
      appBar: AppBar(title: Text('${s.achievements} 🏆')),
      body: Consumer<WaterProvider>(
        builder: (context, water, _) {
          final liters = (water.lifetimeTotal / 1000);
          _Badge make(String emoji, String id, bool unlocked) {
            final (title, desc) = s.badge(id);
            return _Badge(emoji, title, desc, unlocked);
          }

          final badges = <_Badge>[
            make('💧', 'first', water.lifetimeTotal > 0),
            make('🔥', 'streak3', water.streak >= 3),
            make('⚡', 'streak7', water.streak >= 7),
            make('🎯', 'goal1', water.goalsHitTotal >= 1),
            make('🏅', 'goal10', water.goalsHitTotal >= 10),
            make('🌊', 'liters10', liters >= 10),
            make('🐋', 'liters50', liters >= 50),
            make('📅', 'days7', water.daysTracked >= 7),
          ];
          final unlocked = badges.where((b) => b.unlocked).length;

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              _summaryCard(context, water, unlocked, badges.length),
              const SizedBox(height: 24),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.05,
                children: badges.map((b) => _badgeCard(context, b)).toList(),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _summaryCard(BuildContext context, WaterProvider water, int unlocked,
      int total) {
    final s = context.s;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.accent(context), const Color(0xFF4FC3F7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(s.badgesCount(unlocked, total),
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _summaryItem('🔥', '${water.streak}', s.streak),
              _summaryItem(
                  '🌊',
                  s.litersShort(
                      (water.lifetimeTotal / 1000).toStringAsFixed(1)),
                  s.total),
              _summaryItem('🏅', '${water.goalsHitTotal}', s.goals),
            ],
          ),
        ],
      ),
    );
  }

  Widget _summaryItem(String emoji, String value, String label) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 22)),
        const SizedBox(height: 4),
        Text(value,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold)),
        Text(label,
            style: const TextStyle(color: Colors.white70, fontSize: 12)),
      ],
    );
  }

  Widget _badgeCard(BuildContext context, _Badge b) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.card(context),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
            color: b.unlocked
                ? AppTheme.accent(context)
                : AppTheme.border(context),
            width: b.unlocked ? 2 : 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Opacity(
            opacity: b.unlocked ? 1 : 0.3,
            child: Text(b.emoji, style: const TextStyle(fontSize: 40)),
          ),
          const SizedBox(height: 8),
          Text(b.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: b.unlocked ? null : AppTheme.softText(context))),
          const SizedBox(height: 4),
          Text(b.desc,
              textAlign: TextAlign.center,
              style:
                  TextStyle(fontSize: 11, color: AppTheme.softText(context))),
          const SizedBox(height: 6),
          if (b.unlocked)
            Icon(Icons.check_circle_rounded,
                color: AppTheme.accent(context), size: 18)
          else
            Icon(Icons.lock_rounded,
                color: AppTheme.softText(context), size: 16),
        ],
      ),
    );
  }
}

class _Badge {
  final String emoji, title, desc;
  final bool unlocked;
  _Badge(this.emoji, this.title, this.desc, this.unlocked);
}
