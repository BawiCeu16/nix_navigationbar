import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nix_navigationbar/nix_navigationbar.dart';

void main() {
  testWidgets('NixNavigationBar renders items correctly', (WidgetTester tester) async {
    final items = [
      const NixNavigationBarItem(icon: Icon(Icons.home), label: Text('Home')),
      const NixNavigationBarItem(icon: Icon(Icons.search), label: Text('Search')),
      const NixNavigationBarItem(icon: Icon(Icons.person), label: Text('Profile')),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          bottomNavigationBar: NixNavigationBar(
            items: items,
            currentIndex: 0,
            onTap: (index) {},
          ),
        ),
      ),
    );

    // Verify labels are displayed
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Search'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);

    // Verify icons are displayed
    expect(find.byIcon(Icons.home), findsOneWidget);
    expect(find.byIcon(Icons.search), findsOneWidget);
    expect(find.byIcon(Icons.person), findsOneWidget);
  });

  testWidgets('NixNavigationBar updates selection on tap', (WidgetTester tester) async {
    int selectedIndex = 0;

    final items = [
      const NixNavigationBarItem(icon: Icon(Icons.home), label: Text('Home')),
      const NixNavigationBarItem(icon: Icon(Icons.search), label: Text('Search')),
      const NixNavigationBarItem(icon: Icon(Icons.person), label: Text('Profile')),
    ];

    await tester.pumpWidget(
      StatefulBuilder(
        builder: (context, setState) {
          return MaterialApp(
            home: Scaffold(
              bottomNavigationBar: NixNavigationBar(
                items: items,
                currentIndex: selectedIndex,
                onTap: (index) {
                  setState(() {
                    selectedIndex = index;
                  });
                },
              ),
            ),
          );
        },
      ),
    );

    // Tap on Search item
    await tester.tap(find.text('Search'));
    await tester.pumpAndSettle();

    expect(selectedIndex, 1);

    // Tap on Profile item
    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();

    expect(selectedIndex, 2);
  });

  testWidgets('NixNavigationBar supports horizontal dragging to change tabs', (WidgetTester tester) async {
    int selectedIndex = 0;

    final items = [
      const NixNavigationBarItem(icon: Icon(Icons.home), label: Text('Home')),
      const NixNavigationBarItem(icon: Icon(Icons.search), label: Text('Search')),
      const NixNavigationBarItem(icon: Icon(Icons.person), label: Text('Profile')),
    ];

    await tester.pumpWidget(
      StatefulBuilder(
        builder: (context, setState) {
          return MaterialApp(
            home: Scaffold(
              bottomNavigationBar: NixNavigationBar(
                items: items,
                currentIndex: selectedIndex,
                onTap: (index) {
                  setState(() {
                    selectedIndex = index;
                  });
                },
              ),
            ),
          );
        },
      ),
    );

    // Drag starting on the 'Home' text label to the right
    await tester.drag(find.text('Home'), const Offset(300.0, 0.0));
    await tester.pumpAndSettle();

    // Index should be updated (Search or Profile)
    expect(selectedIndex, greaterThan(0));
  });
}
