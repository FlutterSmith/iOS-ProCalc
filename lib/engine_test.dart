// test/calculator_engine_test.dart

import 'package:cul_flutter/engine.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CalculatorEngine', () {
    final engine = CalculatorEngine();

    test('Evaluates simple addition', () {
      expect(engine.evaluateExpression('2+3'), equals(5));
    });

    test('Evaluates subtraction', () {
      expect(engine.evaluateExpression('5-2'), equals(3));
    });

    test('Evaluates multiplication', () {
      expect(engine.evaluateExpression('4*3'), equals(12));
    });

    test('Evaluates division', () {
      expect(engine.evaluateExpression('10/2'), equals(5));
    });

    test('Evaluates combined operations', () {
      // Note: Operator precedence applies.
      expect(engine.evaluateExpression('2+3*4'), equals(14));
    });

    test('Evaluates expression with parentheses', () {
      expect(engine.evaluateExpression('(2+3)*4'), equals(20));
    });

    test('Evaluates expression with percentage', () {
      expect(engine.evaluateExpression('200*50%'), equals(100));
    });

    test('Handles invalid expression gracefully', () {
      expect(() => engine.evaluateExpression('2++3'), throwsException);
    });
  });
}
