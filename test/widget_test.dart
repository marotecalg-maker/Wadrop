// Basic smoke test for the Wadrop app.

import 'package:flutter_test/flutter_test.dart';

import 'package:chhal_chrbti_man_lma/main.dart';

void main() {
  testWidgets('Home screen shows navigation entries', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const WadropApp());

    // The landing screen exposes the Privacy Policy and Support entries.
    expect(find.text('Wadrop'), findsWidgets);
    expect(find.text('Privacy Policy'), findsOneWidget);
    expect(find.text('Support'), findsOneWidget);
  });
}
