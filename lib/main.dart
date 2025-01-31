import 'package:cul_flutter/models/view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => CalculatorViewModel(),
      child: const CalculatorApp(),
    ),
  );
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Advanced Calculator',
      theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: Colors.black),
      home: const CalculatorPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class CalculatorPage extends StatelessWidget {
  const CalculatorPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final calcVM = Provider.of<CalculatorViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Advanced Calculator'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => _showHistory(context, calcVM.history),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.all(20),
                alignment: Alignment.bottomRight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      calcVM.expression,
                      style: const TextStyle(fontSize: 40, color: Colors.white),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      calcVM.result,
                      style: const TextStyle(
                        fontSize: 50,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildMemoryButton(
                    label: 'M+',
                    onTap: calcVM.memoryAdd,
                  ),
                  _buildMemoryButton(
                    label: 'M-',
                    onTap: calcVM.memorySubtract,
                  ),
                  _buildMemoryButton(
                    label: 'MR',
                    onTap: calcVM.memoryRecall,
                  ),
                  _buildMemoryButton(
                    label: 'MC',
                    onTap: calcVM.memoryClear,
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 5,
              child: _buildButtonsGrid(calcVM),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMemoryButton(
      {required String label, required VoidCallback onTap}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFD4D4D2), // Light gray
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40),
            ),
            padding: const EdgeInsets.all(12),
          ),
          onPressed: onTap,
          child: Text(label, style: const TextStyle(fontSize: 16)),
        ),
      ),
    );
  }

  Widget _buildButtonsGrid(CalculatorViewModel calcVM) {
    // Define button rows.
    final List<List<String>> buttons = [
      ['C', '±', '%', '÷'],
      ['7', '8', '9', '×'],
      ['4', '5', '6', '-'],
      ['1', '2', '3', '+'],
      ['0', '.', '='],
    ];

    return Column(
      children: buttons.map((row) {
        return Expanded(
          child: Row(
            children: row.map((btnText) {
              return _buildCalcButton(btnText, calcVM);
            }).toList(),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCalcButton(String label, CalculatorViewModel calcVM) {
    final bool isOperator = ['÷', '×', '-', '+', '='].contains(label);
    final bool isUtility = ['C', '±', '%'].contains(label);

    Color backgroundColor;
    Color textColor;
    if (isOperator) {
      backgroundColor = const Color(0xFFFF9500); // Orange for operators.
      textColor = Colors.white;
    } else if (isUtility) {
      backgroundColor = const Color(0xFFD4D4D2); // Light gray for utility.
      textColor = Colors.black;
    } else {
      backgroundColor = const Color(0xFF505050); // Dark gray for numbers.
      textColor = Colors.white;
    }

    VoidCallback onTap;
    switch (label) {
      case 'C':
        onTap = calcVM.clearAll;
        break;
      case '±':
        onTap = calcVM.toggleSign;
        break;
      case '%':
        onTap = calcVM.applyPercent;
        break;
      case '=':
        onTap = calcVM.evaluate;
        break;
      case '÷':
        onTap = () => calcVM.appendValue('/');
        break;
      case '×':
        onTap = () => calcVM.appendValue('*');
        break;
      default:
        onTap = () => calcVM.appendValue(label);
    }

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor,
            foregroundColor: textColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40),
            ),
            padding: const EdgeInsets.all(8),
          ),
          onPressed: onTap,
          child: Text(
            label,
            style:
                TextStyle(fontSize: label == '0' ? 28 : 30, color: textColor),
          ),
        ),
      ),
    );
  }

  void _showHistory(BuildContext context, List<CalculatorHistoryItem> history) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          color: Colors.black,
          child: ListView.builder(
            itemCount: history.length,
            itemBuilder: (context, index) {
              final item = history[index];
              return ListTile(
                title: Text(
                  item.expression,
                  style: const TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  item.result,
                  style: const TextStyle(color: Colors.white70),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
