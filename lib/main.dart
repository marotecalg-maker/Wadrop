import 'package:flutter/material.dart';

import 'screens/info_page_theme.dart';
import 'screens/privacy_policy_screen.dart';
import 'screens/support_screen.dart';

void main() {
  runApp(const WadropApp());
}

class WadropApp extends StatelessWidget {
  const WadropApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wadrop',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: WadropInfoColors.accent),
        scaffoldBackgroundColor: WadropInfoColors.bg,
      ),
      home: const HomeScreen(),
    );
  }
}

/// Simple landing screen that links to the Privacy Policy and Support pages.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wadrop'),
        backgroundColor: WadropInfoColors.accent,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('💧', style: TextStyle(fontSize: 72)),
                  const SizedBox(height: 12),
                  const Text(
                    'Wadrop',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: WadropInfoColors.accent,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Stay hydrated, one drop at a time.',
                    style: TextStyle(
                      fontSize: 15,
                      color: WadropInfoColors.soft,
                    ),
                  ),
                  const SizedBox(height: 40),
                  _NavButton(
                    label: 'Privacy Policy',
                    icon: Icons.privacy_tip_outlined,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const PrivacyPolicyScreen(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  _NavButton(
                    label: 'Support',
                    icon: Icons.help_outline,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const SupportScreen()),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        style: FilledButton.styleFrom(
          backgroundColor: WadropInfoColors.accent,
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        onPressed: onTap,
        icon: Icon(icon),
        label: Text(label, style: const TextStyle(fontSize: 16)),
      ),
    );
  }
}
