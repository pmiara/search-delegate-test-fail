import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:search_delegate_test/search_delegate_problem.dart';

void main() {
  testWidgets('First test', (WidgetTester tester) async {
    final delegate = MySearchDelegate(
      searchEngine: MySearchEngine(),
    );
    await tester.pumpWidget(
      TestHomePage(
        delegate: delegate,
      ),
    );
    await tester.tap(find.byIcon(Icons.search));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'query');
    await tester.pumpAndSettle();

    expect(find.byType(ListTile), findsNWidgets(3));
  });

  testWidgets('Second test', (WidgetTester tester) async {
    final delegate = MySearchDelegate(
      searchEngine: MySearchEngine(),
    );
    await tester.pumpWidget(
      TestHomePage(
        delegate: delegate,
      ),
    );
    await tester.tap(find.byIcon(Icons.search));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'query');
    await tester.pumpAndSettle();

    expect(find.byType(ListTile), findsNWidgets(3));
  });
}
