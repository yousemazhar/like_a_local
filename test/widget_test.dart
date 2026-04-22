import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:like_a_local/features/place/presentation/place_screen.dart';

void main() {
  testWidgets('PlaceScreen builds without negative margin assertion',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: PlaceScreen(placeId: 'place-123'),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(PlaceScreen), findsOneWidget);
    expect(find.text('Tasca do Chico'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
