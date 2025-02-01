// lib/calculator_view_model.dart

import 'package:cul_flutter/engine.dart';
import 'package:flutter/material.dart';

class CalculatorHistoryItem {
  final String expression;
  final String result;
  CalculatorHistoryItem({required this.expression, required this.result});
}

class CalculatorViewModel extends ChangeNotifier {
  final CalculatorEngine _engine = CalculatorEngine();

  String _expression = '';
  String _result = '0';
  double _memory = 0.0;
  final List<CalculatorHistoryItem> _history = [];

  String get expression => _expression;
  String get result => _result;
  double get memory => _memory;
  List<CalculatorHistoryItem> get history => List.unmodifiable(_history);

  void appendValue(String value) {
    _expression += value;
    notifyListeners();
  }

  void clearAll() {
    _expression = '';
    _result = '';
    notifyListeners();
  }

  void deleteLast() {
    if (_expression.isNotEmpty) {
      _expression = _expression.substring(0, _expression.length - 1);
      notifyListeners();
    }
  }

  void toggleSign() {
    try {
      final double value = double.parse(_expression);
      _expression = (-value).toString();
      notifyListeners();
    } catch (_) {}
  }

  void applyPercent() {
    _expression += '%';
    notifyListeners();
  }

  void evaluate() {
    try {
      final double eval = _engine.evaluateExpression(_expression);
      _result = eval.toString();

      _history
          .add(CalculatorHistoryItem(expression: _expression, result: _result));

      _expression = _result;
    } catch (e) {
      _result = 'Error';
    }
    notifyListeners();
  }

  void memoryAdd() {
    try {
      final double current = double.parse(_result);
      _memory += current;
    } catch (_) {}
    notifyListeners();
  }

  void memorySubtract() {
    try {
      final double current = double.parse(_result);
      _memory -= current;
    } catch (_) {}
    notifyListeners();
  }

  void memoryClear() {
    _memory = 0.0;
    notifyListeners();
  }

  void memoryRecall() {
    _expression = _memory.toString();
    notifyListeners();
  }
}
