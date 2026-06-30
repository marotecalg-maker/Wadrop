import 'package:flutter/material.dart';

import 'info_page_theme.dart';

/// Wadrop Support page, ported from the old `support.html`.
class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WadropInfoColors.bg,
      appBar: AppBar(
        title: const Text('Support'),
        backgroundColor: WadropInfoColors.accent,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(22, 16, 22, 80),
              children: const [
                InfoHeader(
                  title: 'Wadrop Support',
                  subtitle: 'Stay hydrated, one drop at a time.',
                ),
                SizedBox(height: 16),
                InfoParagraph(
                  'Welcome to the Wadrop support page. Wadrop is a simple '
                  'water and drink tracker that helps you reach your daily '
                  "hydration goal. If you need help or have a question, you'll "
                  'find answers below or you can reach us directly.',
                ),
                InfoSectionTitle('Contact Us'),
                InfoParagraph(
                  'The fastest way to get help is by email. We usually reply '
                  'within 1–2 business days.',
                ),
                InfoCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Email:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: WadropInfoColors.text,
                        ),
                      ),
                      SizedBox(height: 8),
                      InfoEmail('a.elbouni1996@gmail.com'),
                    ],
                  ),
                ),
                InfoSectionTitle('Frequently Asked Questions'),
                _FaqItem(
                  question: 'How do I log a drink?',
                  answer: 'Tap one of your favorite presets on the home '
                      'screen, or tap "Add drink" to choose a drink type and '
                      'amount.',
                ),
                _FaqItem(
                  question: 'How do I change my daily goal?',
                  answer: 'Open Settings ⚙️ and use the slider or the preset '
                      'chips under "Daily goal".',
                ),
                _FaqItem(
                  question: 'How do I change the app language?',
                  answer: 'Open Settings ⚙️ and choose your language (English, '
                      'Arabic, or French) under "Language". The whole app '
                      'updates instantly.',
                ),
                _FaqItem(
                  question: 'How do I switch between light and dark mode?',
                  answer: 'Tap the sun/moon icon in the top bar, or pick a '
                      'theme under "Appearance" in Settings.',
                ),
                _FaqItem(
                  question: 'Where is my data stored?',
                  answer: 'All your data is stored locally on your device '
                      'only. Nothing is sent to any server. See our Privacy '
                      'Policy for details.',
                ),
                _FaqItem(
                  question: 'How do I delete an entry?',
                  answer: 'In "Today\'s log", swipe an entry to remove it, or '
                      'tap "Undo" to remove the last one you added.',
                ),
                _FaqItem(
                  question: 'Will I lose my data if I delete the app?',
                  answer: 'Yes. Because data is stored only on your device, '
                      'uninstalling the app removes all saved logs and '
                      'settings.',
                ),
                InfoFooter('© 2026 Wadrop. All rights reserved.'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// A single FAQ entry: bold question followed by a soft-colored answer.
class _FaqItem extends StatelessWidget {
  const _FaqItem({required this.question, required this.answer});

  final String question;
  final String answer;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: WadropInfoColors.text,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            answer,
            style: const TextStyle(
              fontSize: 16,
              height: 1.7,
              color: WadropInfoColors.soft,
            ),
          ),
        ],
      ),
    );
  }
}
