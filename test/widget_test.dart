// This is a basic Flutter widget test for the Message Board app.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:message_board_app/main.dart';

void main() {
  testWidgets('App starts with splash screen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MessageBoardApp());

    // Verify that splash screen elements are present
    expect(find.text('Message Board App'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
