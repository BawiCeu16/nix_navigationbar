import 'package:flutter_test/flutter_test.dart';
import 'package:example/main.dart';

void main() {
  testWidgets('Example app rendering test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const NixDemoApp());

    // Verify that the title is displayed.
    expect(find.text('Dynamic Pill Layout'), findsOneWidget);
  });
}
