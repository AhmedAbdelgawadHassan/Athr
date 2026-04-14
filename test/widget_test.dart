// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:athr/core/services/shared_prefrence.dart';
import 'package:athr/features/languageAndlocation/presentation/manager/locale_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:athr/main.dart';

void main() {
  testWidgets('Athr app builds root MaterialApp', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    await Prefs.init();

    await tester.pumpWidget(
      BlocProvider(
        create: (_) => LocaleCubit(),
        child: const Athr(),
      ),
    );
    await tester.pump(const Duration(seconds: 5));

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
