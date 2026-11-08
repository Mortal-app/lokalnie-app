import 'package:flutter/widgets.dart';

/// True inside `flutter test` (AutomatedTestWidgetsFlutterBinding and siblings).
bool get isFlutterWidgetTest {
  final name = WidgetsBinding.instance.runtimeType.toString();
  return name.contains('TestWidgets') || name.contains('AutomatedTest');
}
