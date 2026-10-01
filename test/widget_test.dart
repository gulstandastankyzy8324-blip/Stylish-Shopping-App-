import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/main.dart';

void main() {
  testWidgets('shows splash page', (WidgetTester tester) async {
    await tester.pumpWidget(const StylishApp());

    expect(find.byType(GestureDetector), findsOneWidget);
  });
}
