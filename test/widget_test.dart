import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:stadium/app.dart';

void main() {
  testWidgets('Studium app smoke test', (WidgetTester tester) async {
    // Build the app
    await tester.pumpWidget(const StudiumApp());

    // Vérifie que l'app démarre
    expect(find.text('Studium App'), findsOneWidget);
  });
}
