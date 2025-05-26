import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Helper class for common test utilities
class TestHelper {
  /// Creates a test widget with the given child
  static Widget createTestableWidget(Widget child) {
    return MaterialApp(
      home: Scaffold(
        body: child,
      ),
    );
  }

  /// Finds a widget by its key
  static Finder findByKey(String key) {
    return find.byKey(Key(key));
  }

  /// Finds a widget by its type
  static Finder findByType<T>() {
    return find.byType(T);
  }

  /// Finds a widget by its text
  static Finder findByText(String text) {
    return find.text(text);
  }
} 