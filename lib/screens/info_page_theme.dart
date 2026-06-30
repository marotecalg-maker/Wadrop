import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Shared palette for the Wadrop info pages (Privacy Policy & Support).
/// Mirrors the original CSS variables used in the old HTML pages.
class WadropInfoColors {
  static const Color accent = Color(0xFF0288D1);
  static const Color text = Color(0xFF1A2530);
  static const Color soft = Color(0xFF5B6B78);
  static const Color bg = Color(0xFFFFFFFF);
  static const Color card = Color(0xFFF3F9FD);
  static const Color border = Color(0xFFDCEAF3);
}

/// Centered page header with the water-drop logo, a title and a subtitle.
class InfoHeader extends StatelessWidget {
  const InfoHeader({super.key, required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 28, bottom: 18),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: WadropInfoColors.border)),
      ),
      child: Column(
        children: [
          const Text('💧', style: TextStyle(fontSize: 46)),
          const SizedBox(height: 10),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: WadropInfoColors.accent,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              color: WadropInfoColors.soft,
            ),
          ),
        ],
      ),
    );
  }
}

/// A section heading rendered in the accent color (the old `<h2>`).
class InfoSectionTitle extends StatelessWidget {
  const InfoSectionTitle(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 34, bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: WadropInfoColors.accent,
        ),
      ),
    );
  }
}

/// A body paragraph (the old `<p>`).
class InfoParagraph extends StatelessWidget {
  const InfoParagraph(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          height: 1.7,
          color: WadropInfoColors.text,
        ),
      ),
    );
  }
}

/// A soft, rounded highlight box (the old `.card`).
class InfoCard extends StatelessWidget {
  const InfoCard({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 18),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: WadropInfoColors.card,
        border: Border.all(color: WadropInfoColors.border),
        borderRadius: BorderRadius.circular(14),
      ),
      child: child,
    );
  }
}

/// A simple bullet list (the old `<ul>`).
class InfoBulletList extends StatelessWidget {
  const InfoBulletList(this.items, {super.key});

  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 6, top: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final item in items)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '•  ',
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.7,
                      color: WadropInfoColors.text,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      item,
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.7,
                        color: WadropInfoColors.text,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// A tappable email row that copies the address to the clipboard
/// (replaces the old `mailto:` link, with no extra dependencies).
class InfoEmail extends StatelessWidget {
  const InfoEmail(this.email, {super.key});

  final String email;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Clipboard.setData(ClipboardData(text: email));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Email copied: $email')),
        );
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('📧  ', style: TextStyle(fontSize: 16)),
          Flexible(
            child: Text(
              email,
              style: const TextStyle(
                fontSize: 16,
                color: WadropInfoColors.accent,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// The closing copyright line (the old `.footer`).
class InfoFooter extends StatelessWidget {
  const InfoFooter(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 48),
      padding: const EdgeInsets.only(top: 20),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: WadropInfoColors.border)),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 13,
          color: WadropInfoColors.soft,
        ),
      ),
    );
  }
}
