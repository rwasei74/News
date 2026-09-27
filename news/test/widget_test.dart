import 'package:flutter_test/flutter_test.dart';
import 'package:news/main.dart';
import 'package:news/screens/home/home_screen.dart';
import 'package:news/screens/splash/splash_screen.dart';

void main() {
  testWidgets('App splash test and transition to home', (WidgetTester tester) async {
    await tester.pumpWidget(const NewsApp());
    await tester.pump();

    // Verify SplashScreen is loaded initially
    expect(find.byType(SplashScreen), findsOneWidget);

    // Fast-forward 3.5 seconds to finish timer and animation
    await tester.pumpAndSettle(const Duration(seconds: 4));

    // Verify HomeScreen is now displayed
    expect(find.byType(HomeScreen), findsOneWidget);
  });
}
