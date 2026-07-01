import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/water_provider.dart';
import '../providers/theme_provider.dart';
import '../providers/locale_provider.dart';
import '../l10n/strings.dart';
import '../theme/app_theme.dart';

/// شاشة الإعدادات: اللغة + الهدف اليومي + السمة (فاتح/داكن/النظام).
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  static const _presets = [1500, 2000, 2500, 3000];

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    return Scaffold(
      appBar: AppBar(title: Text('${s.settings} ⚙️')),
      body: Consumer3<WaterProvider, ThemeProvider, LocaleProvider>(
        builder: (context, water, theme, localeProvider, _) {
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              _card(context, [
                _header(Icons.language_rounded, s.language, context),
                const SizedBox(height: 12),
                Material(
                  type: MaterialType.transparency,
                  child: RadioGroup<String>(
                    groupValue: localeProvider.code,
                    onChanged: (code) =>
                        localeProvider.setLanguage(code ?? 'en'),
                    child: Column(
                      children: Strings.languageNames.entries
                          .map((e) => RadioListTile<String>(
                                value: e.key,
                                title: Text(e.value),
                                activeColor: AppTheme.accent(context),
                                contentPadding: EdgeInsets.zero,
                              ))
                          .toList(),
                    ),
                  ),
                ),
              ]),
              const SizedBox(height: 20),
              _card(context, [
                _header(Icons.flag_rounded, s.dailyGoal, context),
                const SizedBox(height: 8),
                Text(s.mlPerDay(water.dailyGoal),
                    style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.accent(context))),
                const SizedBox(height: 8),
                Slider(
                  value: water.dailyGoal.clamp(500, 5000).toDouble(),
                  min: 500,
                  max: 5000,
                  divisions: 90,
                  label: s.mlWithUnit(water.dailyGoal),
                  activeColor: AppTheme.accent(context),
                  onChanged: (v) => water.setGoal((v / 50).round() * 50),
                ),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: _presets.map((p) {
                    final selected = water.dailyGoal == p;
                    return ChoiceChip(
                      label: Text(s.mlWithUnit(p)),
                      selected: selected,
                      onSelected: (_) => water.setGoal(p),
                      selectedColor: AppTheme.accent(context),
                      labelStyle: TextStyle(
                          color: selected ? Colors.white : null),
                    );
                  }).toList(),
                ),
              ]),
              const SizedBox(height: 20),
              _card(context, [
                _header(Icons.palette_rounded, s.appearance, context),
                const SizedBox(height: 12),
                Material(
                  type: MaterialType.transparency,
                  child: RadioGroup<ThemeMode>(
                    groupValue: theme.mode,
                    onChanged: (m) => theme.setMode(m ?? ThemeMode.system),
                    child: Column(
                      children: [
                        _themeOption(context, ThemeMode.light, s.light),
                        _themeOption(context, ThemeMode.dark, s.dark),
                        _themeOption(context, ThemeMode.system, s.system),
                      ],
                    ),
                  ),
                ),
              ]),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppTheme.accent(context).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Icon(Icons.lightbulb_rounded,
                        color: AppTheme.accent(context)),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        s.tip,
                        style: const TextStyle(fontSize: 14, height: 1.5),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: Text('${s.appTitle} • v2.0',
                    style: TextStyle(
                        color: AppTheme.softText(context), fontSize: 12)),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _card(BuildContext context, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.card(context),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.border(context)),
      ),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch, children: children),
    );
  }

  Widget _header(IconData icon, String title, BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppTheme.accent(context)),
        const SizedBox(width: 8),
        Text(title,
            style:
                const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _themeOption(BuildContext context, ThemeMode mode, String label) {
    return RadioListTile<ThemeMode>(
      value: mode,
      title: Text(label),
      activeColor: AppTheme.accent(context),
      contentPadding: EdgeInsets.zero,
    );
  }
}
