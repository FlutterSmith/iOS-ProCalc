// lib/calculator_view_model.dart

import 'package:cul_flutter/engine.dart';
import 'package:flutter/material.dart';

/// A simple model to store a history item (expression and result).
class CalculatorHistoryItem {
  final String expression;
  final String result;
  CalculatorHistoryItem({required this.expression, required this.result});
}

/// A ChangeNotifier-based view model that handles calculator state.
class CalculatorViewModel extends ChangeNotifier {
  final CalculatorEngine _engine = CalculatorEngine();

  String _expression = '';
  String _result = '';
  double _memory = 0.0;
  final List<CalculatorHistoryItem> _history = [];

  String get expression => _expression;
  String get result => _result;
  double get memory => _memory;
  List<CalculatorHistoryItem> get history => List.unmodifiable(_history);

  /// Appends a digit, operator, or function to the current expression.
  void appendValue(String value) {
    _expression += value;
    notifyListeners();
  }

  /// Clears the current expression and result.
  void clearAll() {
    _expression = '';
    _result = '';
    notifyListeners();
  }

  /// Deletes the last character from the current expression.
  void deleteLast() {
    if (_expression.isNotEmpty) {
      _expression = _expression.substring(0, _expression.length - 1);
      notifyListeners();
    }
  }

  /// Toggles the sign of the current expression if it is a valid number.
  void toggleSign() {
    try {
      final double value = double.parse(_expression);
      _expression = (-value).toString();
      notifyListeners();
    } catch (_) {
      // No action if expression is not a pure number.
    }
  }

  /// Appends a percentage symbol to the expression.
  void applyPercent() {
    _expression += '%';
    notifyListeners();
  }

  /// Evaluates the current expression.
  void evaluate() {
    try {
      final double eval = _engine.evaluateExpression(_expression);
      _result = eval.toString();

      // Add the evaluated expression to history.
      _history.add(CalculatorHistoryItem(expression: _expression, result: _result));

      // Optionally, set the expression to the result for chaining.
      _expression = _result;
    } catch (e) {
      _result = 'Error';
    }
    notifyListeners();
  }

  // Memory functions:

  /// Adds the current result to memory.
  void memoryAdd() {
    try {
      final double current = double.parse(_result);
      _memory += current;
    } catch (_) {}
    notifyListeners();
  }

  /// Subtracts the current result from memory.
  void memorySubtract() {
    try {
      final double current = double.parse(_result);
      _memory -= current;
    } catch (_) {}
    notifyListeners();
  }

  /// Clears the stored memory.
  void memoryClear() {
    _memory = 0.0;
    notifyListeners();
  }

  /// Recalls the stored memory value to the current expression.
  void memoryRecall() {
    _expression = _memory.toString();
    notifyListeners();
  }
}
