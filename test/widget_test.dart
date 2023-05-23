// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:news_app2/layout/home_layout.dart';

import 'package:news_app2/main.dart';
import 'package:news_app2/modules/login/login_screen.dart';
import 'package:news_app2/shared/components/constants.dart';
import 'package:news_app2/shared/network/local/cache_helper.dart';

void main() {


  bool isDark = CacheHelper.getData(key: 'DarkMood') == null ? false : CacheHelper.getData(key: 'DarkMood');
  uId = CacheHelper.getData(key: 'uId') == null ? "" : CacheHelper.getData(key: 'uId');


  Widget screen;

  if(uId != "")
  {
    screen = HomeLayout();
  }
  else
  {
    screen = LoginScreen();
  }

  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp(screen, isDark));

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
