// test/widget_test.dart

import 'package:cul_flutter/main.dart';
import 'package:cul_flutter/models/view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';


void main() {
  testWidgets('Calculator UI interaction test', (WidgetTester tester) async {
    // Build the app.
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => CalculatorViewModel(),
        child: const CalculatorApp(),
      ),
    );

    // Tap the "7" button.
    final button7 = find.text('7');
    expect(button7, findsOneWidget);
    await tester.tap(button7);
    await tester.pump();

    // Tap the "+" button.
    final plusButton = find.text('+');
    await tester.tap(plusButton);
    await tester.pump();

    // Tap the "3" button.
    final button3 = find.text('3');
    await tester.tap(button3);
    await tester.pump();

    // Tap the "=" button.
    final equalsButton = find.text('=');
    await tester.tap(equalsButton);
    await tester.pump();

    // Expect the result to be "10.0".
    expect(find.text('10.0'), findsOneWidget);
  });
}
