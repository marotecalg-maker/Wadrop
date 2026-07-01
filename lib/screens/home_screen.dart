import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/water_provider.dart';
import '../providers/theme_provider.dart';
import '../providers/locale_provider.dart';
import '../models/water_entry.dart';
import '../models/favorite.dart';
import '../models/drink_type.dart';
import '../theme/app_theme.dart';
import '../widgets/water_wave.dart';
import '../widgets/celebration.dart';
import 'history_screen.dart';
import 'settings_screen.dart';
import 'achievements_screen.dart';

/// الشاشة الرئيسية: دائرة الماء + المفضّلات + سجل اليوم.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final s = context.s;
    return Scaffold(
      appBar: AppBar(
        title: Text(s.appTitle),
        actions: [
          IconButton(
            icon: Icon(dark ? Icons.light_mode_rounded : Icons.dark_mode_rounded),
            tooltip: s.nightMode,
            onPressed: () => context.read<ThemeProvider>().toggle(),
          ),
          IconButton(
            icon: const Icon(Icons.emoji_events_rounded),
            tooltip: s.achievements,
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const AchievementsScreen())),
          ),
          IconButton(
            icon: const Icon(Icons.bar_chart_rounded),
            tooltip: s.statistics,
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const HistoryScreen())),
          ),
          IconButton(
            icon: const Icon(Icons.settings_rounded),
            tooltip: s.settings,
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const SettingsScreen())),
          ),
        ],
      ),
      body: Consumer<WaterProvider>(
        builder: (context, water, _) {
          if (!water.loaded) {
            return const Center(child: CircularProgressIndicator());
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _statsRow(context, water),
                const SizedBox(height: 16),
                Center(
                  child: WaterWave(
                    progress: water.progress,
                    currentMl: water.todayTotal,
                    goalMl: water.dailyGoal,
                    dark: dark,
                    unit: s.ml,
                  ),
                ),
                const SizedBox(height: 16),
                _remainingBanner(context, water),
                const SizedBox(height: 24),
                _sectionTitle(context, s.favorites, onAdd: () {
                  _showAddDrinkSheet(context, water, asFavorite: true);
                }),
                const SizedBox(height: 12),
                _favoritesGrid(context, water),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: () => _showAddDrinkSheet(context, water),
                        icon: const Icon(Icons.add_rounded),
                        label: Text(s.addDrink),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: water.todayEntries.isEmpty
                            ? null
                            : () => water.undoLast(),
                        icon: const Icon(Icons.undo_rounded),
                        label: Text(s.undo),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _todayList(context, water),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }

  // ----- الأقسام -----

  Widget _statsRow(BuildContext context, WaterProvider water) {
    final s = context.s;
    return Row(
      children: [
        _miniStat(context, '🔥', '${water.streak}', s.dayStreak),
        const SizedBox(width: 12),
        _miniStat(context, '🥤', '${water.todayCount}', s.cupsToday),
        const SizedBox(width: 12),
        _miniStat(context, '🎯', '${(water.progress * 100).round()}%', s.ofGoal),
      ],
    );
  }

  Widget _miniStat(
      BuildContext context, String emoji, String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: AppTheme.card(context),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.border(context)),
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 4),
            Text(value,
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold)),
            Text(label,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 11, color: AppTheme.softText(context))),
          ],
        ),
      ),
    );
  }

  Widget _remainingBanner(BuildContext context, WaterProvider water) {
    final s = context.s;
    final done = water.remaining == 0;
    final color = done ? Colors.green : AppTheme.accent(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(done ? Icons.celebration_rounded : Icons.water_drop_rounded,
              color: color),
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              done ? s.goalReachedBanner : s.remainingToGoal(water.remaining),
              style: TextStyle(
                  fontSize: 15, fontWeight: FontWeight.w700, color: color),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(BuildContext context, String title,
      {VoidCallback? onAdd}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        if (onAdd != null)
          IconButton(
            icon: Icon(Icons.add_circle_outline_rounded,
                color: AppTheme.accent(context)),
            tooltip: context.s.addToFavorites,
            onPressed: onAdd,
          ),
      ],
    );
  }

  Widget _favoritesGrid(BuildContext context, WaterProvider water) {
    final s = context.s;
    final favs = water.favorites;
    if (favs.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        alignment: Alignment.center,
        child: Text(s.noFavorites,
            textAlign: TextAlign.center,
            style: TextStyle(color: AppTheme.softText(context))),
      );
    }
    return GridView.count(
      crossAxisCount: 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 0.82,
      children: favs.map((fav) {
        final drink = DrinkType.byId(fav.drinkId);
        return InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _quickAdd(context, water, fav.amount, fav.drinkId),
          onLongPress: () => _confirmRemoveFavorite(context, water, fav),
          child: Container(
            decoration: BoxDecoration(
              color: AppTheme.card(context),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: drink.color.withValues(alpha: 0.4)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(drink.emoji, style: const TextStyle(fontSize: 24)),
                const SizedBox(height: 4),
                Text('${fav.amount}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15)),
                Text(s.ml,
                    style: TextStyle(
                        fontSize: 10, color: AppTheme.softText(context))),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _todayList(BuildContext context, WaterProvider water) {
    final s = context.s;
    final entries = water.todayEntries;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(s.todayLog,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        if (entries.isEmpty)
          Container(
            padding: const EdgeInsets.all(24),
            alignment: Alignment.center,
            child: Text(s.emptyToday,
                textAlign: TextAlign.center,
                style: TextStyle(color: AppTheme.softText(context))),
          )
        else
          ...entries.map((e) => _entryTile(context, water, e)),
      ],
    );
  }

  Widget _entryTile(BuildContext context, WaterProvider water, WaterEntry e) {
    final s = context.s;
    final drink = DrinkType.byId(e.drinkId);
    final t = e.time;
    final timeStr =
        '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
    return Dismissible(
      key: ValueKey(e.time.toIso8601String() + e.amount.toString()),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => water.removeEntry(e),
      background: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 20),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
            color: Colors.red.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12)),
        child: const Icon(Icons.delete_rounded, color: Colors.red),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
            color: AppTheme.card(context),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.border(context))),
        clipBehavior: Clip.antiAlias,
        child: Material(
          type: MaterialType.transparency,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: drink.color.withValues(alpha: 0.15),
              child: Text(drink.emoji, style: const TextStyle(fontSize: 20)),
            ),
            title: Text(s.entryTitle(e.amount, s.drinkName(e.drinkId)),
                style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(s.atTime(timeStr)),
            trailing: Icon(Icons.swipe_left_rounded,
                color: AppTheme.softText(context), size: 18),
          ),
        ),
      ),
    );
  }

  // ----- منطق الإضافة -----

  Future<void> _quickAdd(BuildContext context, WaterProvider water, int amount,
      String drinkId) async {
    final s = context.s;
    final completed = await water.addWater(amount, drinkId: drinkId);
    if (!context.mounted) return;
    if (completed) {
      showCelebration(context);
    }
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text(s.addedSnack(amount, DrinkType.byId(drinkId).emoji)),
        duration: const Duration(milliseconds: 900),
        behavior: SnackBarBehavior.floating,
      ));
  }

  void _confirmRemoveFavorite(
      BuildContext context, WaterProvider water, Favorite fav) {
    final s = context.s;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(s.removeFavoriteTitle),
        content: Text(
            s.entryTitle(fav.amount, s.drinkName(fav.drinkId))),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(s.cancel)),
          FilledButton(
            onPressed: () {
              water.removeFavorite(fav);
              Navigator.pop(ctx);
            },
            child: Text(s.delete),
          ),
        ],
      ),
    );
  }

  /// ورقة سفلية لاختيار نوع المشروب والكمية.
  void _showAddDrinkSheet(BuildContext context, WaterProvider water,
      {bool asFavorite = false}) {
    String selectedDrink = 'water';
    int amount = 250;
    final controller = TextEditingController(text: '250');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.card(context),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) {
        final s = ctx.s;
        return StatefulBuilder(
          builder: (ctx, setSheet) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                          color: AppTheme.border(ctx),
                          borderRadius: BorderRadius.circular(2)),
                    ),
                  ),
                  Text(asFavorite ? s.addNewFavorite : s.addDrink,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  Text(s.drinkType,
                      style: TextStyle(color: AppTheme.softText(ctx))),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: DrinkType.all.map((d) {
                      final selected = d.id == selectedDrink;
                      return ChoiceChip(
                        label: Text('${d.emoji} ${s.drinkName(d.id)}'),
                        selected: selected,
                        onSelected: (_) =>
                            setSheet(() => selectedDrink = d.id),
                        selectedColor: d.color,
                        labelStyle: TextStyle(
                            color: selected ? Colors.white : null,
                            fontWeight: FontWeight.w600),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  Text(s.amountMl,
                      style: TextStyle(color: AppTheme.softText(ctx))),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [100, 150, 200, 250, 330, 500].map((v) {
                      return ActionChip(
                        label: Text('$v'),
                        onPressed: () => setSheet(() {
                          amount = v;
                          controller.text = '$v';
                        }),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: controller,
                    keyboardType: TextInputType.number,
                    onChanged: (v) => amount = int.tryParse(v) ?? amount,
                    decoration: InputDecoration(
                      suffixText: s.ml,
                      border: const OutlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                  const SizedBox(height: 20),
                  FilledButton(
                    onPressed: () {
                      final v = int.tryParse(controller.text.trim()) ?? 0;
                      if (v <= 0) return;
                      Navigator.pop(ctx);
                      if (asFavorite) {
                        water.addFavorite(
                            Favorite(amount: v, drinkId: selectedDrink));
                      } else {
                        _quickAdd(context, water, v, selectedDrink);
                      }
                    },
                    child: Text(asFavorite ? s.saveFavorite : s.add),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
