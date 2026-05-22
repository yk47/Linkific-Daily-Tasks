import 'package:flutter/material.dart';

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String _display = '0';
  double? _first;
  String? _op;
  bool _shouldClear = false;

  void _input(String value) {
    setState(() {
      if (_shouldClear || _display == '0') {
        _display = value;
        _shouldClear = false;
      } else {
        _display = _display + value;
      }
    });
  }

  void _setOp(String operator) {
    setState(() {
      _first = double.tryParse(_display) ?? 0.0;
      _op = operator;
      _shouldClear = true;
    });
  }

  void _clear() {
    setState(() {
      _display = '0';
      _first = null;
      _op = null;
      _shouldClear = false;
    });
  }

  void _calculate() {
    setState(() {
      final second = double.tryParse(_display) ?? 0.0;
      double res = second;
      if (_first != null && _op != null) {
        switch (_op) {
          case '+':
            res = _first! + second;
            break;
          case '-':
            res = _first! - second;
            break;
          case '×':
            res = _first! * second;
            break;
          case '÷':
            res = second != 0 ? _first! / second : double.nan;
            break;
        }
      }
      _display = res.isNaN ? 'Error' : _format(res);
      _first = null;
      _op = null;
      _shouldClear = true;
    });
  }

  String _format(double v) {
    if (v == v.truncateToDouble()) return v.toInt().toString();
    return v.toString();
  }

  Widget _button(String label, {Color? color, VoidCallback? onTap}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: color),
          onPressed: onTap,
          child: Text(label, style: const TextStyle(fontSize: 20)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
            alignment: Alignment.bottomRight,
            color: Colors.black12,
            padding: const EdgeInsets.all(24),
            child: Text(_display, style: const TextStyle(fontSize: 48)),
          ),
        ),
        Column(
          children: [
            Row(
              children: [
                _button('7', onTap: () => _input('7')),
                _button('8', onTap: () => _input('8')),
                _button('9', onTap: () => _input('9')),
                _button('÷', color: Colors.orange, onTap: () => _setOp('÷')),
              ],
            ),
            Row(
              children: [
                _button('4', onTap: () => _input('4')),
                _button('5', onTap: () => _input('5')),
                _button('6', onTap: () => _input('6')),
                _button('×', color: Colors.orange, onTap: () => _setOp('×')),
              ],
            ),
            Row(
              children: [
                _button('1', onTap: () => _input('1')),
                _button('2', onTap: () => _input('2')),
                _button('3', onTap: () => _input('3')),
                _button('-', color: Colors.orange, onTap: () => _setOp('-')),
              ],
            ),
            Row(
              children: [
                _button('0', onTap: () => _input('0')),
                _button('.', onTap: () => _input('.')),
                _button('C', color: Colors.redAccent, onTap: _clear),
                _button('+', color: Colors.orange, onTap: () => _setOp('+')),
              ],
            ),
            Row(
              children: [_button('=', color: Colors.green, onTap: _calculate)],
            ),
          ],
        ),
      ],
    );
  }
}
