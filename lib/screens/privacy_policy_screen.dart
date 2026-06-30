import 'package:flutter/material.dart';

import 'info_page_theme.dart';

/// Wadrop Privacy Policy page, ported from the old `privacy_policy.html`.
class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WadropInfoColors.bg,
      appBar: AppBar(
        title: const Text('Privacy Policy'),
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
                  title: 'Privacy Policy',
                  subtitle: 'Wadrop · Last updated: June 30, 2026',
                ),
                SizedBox(height: 16),
                InfoParagraph(
                  'This Privacy Policy explains how the Wadrop mobile '
                  'application ("the App", "we", "us") handles your '
                  'information. Your privacy is important to us. Please read '
                  'this policy carefully.',
                ),
                InfoCard(
                  child: Text(
                    'In short: Wadrop does not collect, store, or share any '
                    'personal data on external servers. All your data stays on '
                    'your device.',
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.7,
                      fontWeight: FontWeight.w600,
                      color: WadropInfoColors.text,
                    ),
                  ),
                ),
                InfoSectionTitle('1. Information We Do Not Collect'),
                InfoParagraph(
                  'Wadrop does not require you to create an account and does '
                  'not ask for personal information such as your name, email '
                  'address, phone number, or location. We do not collect, '
                  'track, or transmit any personally identifiable information.',
                ),
                InfoSectionTitle('2. Data Stored on Your Device'),
                InfoParagraph(
                  'To provide its features, the App stores the following '
                  'information locally on your device only:',
                ),
                InfoBulletList([
                  'Your water and drink intake logs (amounts and times).',
                  'Your daily hydration goal.',
                  'Your favorite drink presets.',
                  'Your app preferences (theme and language).',
                ]),
                InfoParagraph(
                  "This data is saved on your device using the operating "
                  "system's local storage. It is never uploaded to us or to "
                  "any third party. If you delete the App, this data is "
                  "removed from your device.",
                ),
                InfoSectionTitle('3. No Third-Party Services'),
                InfoParagraph(
                  'Wadrop does not use third-party analytics, advertising '
                  'networks, or tracking tools. The App does not contain ads '
                  'and does not share data with external companies.',
                ),
                InfoSectionTitle('4. Internet Access'),
                InfoParagraph(
                  'Wadrop works fully offline and does not need an internet '
                  'connection to function. It does not send your data over the '
                  'network.',
                ),
                InfoSectionTitle("5. Children's Privacy"),
                InfoParagraph(
                  'Wadrop is suitable for general audiences and does not '
                  'knowingly collect any data from children. Because no '
                  'personal data is collected at all, the App poses no '
                  'data-related risk to users of any age.',
                ),
                InfoSectionTitle('6. Data Security'),
                InfoParagraph(
                  'Since all information remains on your device, the security '
                  'of that data depends on the security of your device. We '
                  'recommend protecting your device with a passcode or '
                  'biometric lock.',
                ),
                InfoSectionTitle('7. Your Rights'),
                InfoParagraph(
                  'You are in full control of your data. You can delete '
                  'individual entries inside the App at any time, or remove all '
                  'stored data by uninstalling the App.',
                ),
                InfoSectionTitle('8. Changes to This Policy'),
                InfoParagraph(
                  'We may update this Privacy Policy from time to time. Any '
                  'changes will be reflected on this page with an updated '
                  '"Last updated" date. We encourage you to review this policy '
                  'periodically.',
                ),
                InfoSectionTitle('9. Contact Us'),
                InfoParagraph(
                  'If you have any questions about this Privacy Policy or the '
                  'App, you can contact us at:',
                ),
                InfoCard(child: InfoEmail('a.elbouni1996@gmail.com')),
                InfoFooter('© 2026 Wadrop. All rights reserved.'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
