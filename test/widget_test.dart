// Smoke test: التطبيق كيقلع بالإنجليزية افتراضيا.
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:chhal_chrbti_man_lma/main.dart';
import 'package:chhal_chrbti_man_lma/providers/water_provider.dart';
import 'package:chhal_chrbti_man_lma/providers/theme_provider.dart';
import 'package:chhal_chrbti_man_lma/providers/locale_provider.dart';

void main() {
  testWidgets('App boots in English by default', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => WaterProvider()..load()),
          ChangeNotifierProvider(create: (_) => ThemeProvider()..load()),
          ChangeNotifierProvider(create: (_) => LocaleProvider()..load()),
        ],
        child: const MyApp(),
      ),
    );
    await tester.pumpAndSettle();

    // النصوص الإنجليزية كاينة فالشاشة الرئيسية.
    expect(find.text('Add drink'), findsOneWidget);
    expect(find.text("Today's log 📋"), findsOneWidget);
  });
}
