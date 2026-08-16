import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:bible/main.dart';
import 'package:bible/providers/notification_provider.dart';
import 'package:bible/providers/tts_provider.dart';

void main() {
  testWidgets('App builds and shows splash screen', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      MyApp(
        prefs: prefs,
        notifications: NotificationProvider(prefs),
        tts: TtsProvider(),
      ),
    );

    expect(find.text('Golden Bible'), findsOneWidget);

    await tester.pump(const Duration(seconds: 4));
  });
}
