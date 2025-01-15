// lib/calculator_engine.dart

import 'package:math_expressions/math_expressions.dart';

/// A class that evaluates arithmetic expressions with advanced support,
/// including trigonometric functions, exponentiation, parentheses, and percentage.
class CalculatorEngine {
  /// Evaluates the provided [expression] string and returns the computed value.
  double evaluateExpression(String expression) {
    try {
      // Replace "%" with "/100" for percentage evaluation.
      final String expStr = expression.replaceAll('%', '/100');

      // Parse and evaluate using math_expressions.
      final Parser parser = Parser();
      final Expression exp = parser.parse(expStr);
      final ContextModel cm = ContextModel();

      return exp.evaluate(EvaluationType.REAL, cm);
    } catch (e) {
      throw Exception('Invalid Expression');
    }
  }
}
