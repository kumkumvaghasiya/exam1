
import 'package:flutter_test/flutter_test.dart';
import '../lib/book_management_app.dart';

void main() {
  testWidgets('Book app displays splash screen', (
      WidgetTester tester,
      ) async {
    await tester.pumpWidget(const BookManagementApp());

    expect(find.text('BOOK MANAGEMENT'), findsOneWidget);
    expect(find.text('Organize Your Book Collection'), findsOneWidget);
  });
}
