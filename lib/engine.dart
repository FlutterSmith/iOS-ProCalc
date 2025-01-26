
import 'package:math_expressions/math_expressions.dart';

class CalculatorEngine {
  double evaluateExpression(String expression) {
    try {
      final String expStr = expression.replaceAll('%', '/100');

      final Parser parser = Parser();
      final Expression exp = parser.parse(expStr);
      final ContextModel cm = ContextModel();

      return exp.evaluate(EvaluationType.REAL, cm);
    } catch (e) {
      throw Exception('Invalid Expression');
    }
  }
}
