import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:integration_test/integration_test_driver.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('Displays a text', (WidgetTester tester) async {
    // Build the widget tree.
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text('Hello, world!'),
          ),
        ),
      ),
    );

    // Verify that the text is displayed.
    expect(find.text('Hello, world!'), findsNothing);
  });
}
