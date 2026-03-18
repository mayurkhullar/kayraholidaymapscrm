import 'package:flutter_test/flutter_test.dart';

import 'package:kayraholidaymapscrm/app.dart';

void main() {
  testWidgets('App opens login screen and navigates to dashboard', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const App());

    expect(find.text('Login Screen'), findsOneWidget);
    expect(find.text('Go to Dashboard'), findsOneWidget);

    await tester.tap(find.text('Go to Dashboard'));
    await tester.pumpAndSettle();

    expect(find.text('Dashboard Screen'), findsOneWidget);
  });
}
