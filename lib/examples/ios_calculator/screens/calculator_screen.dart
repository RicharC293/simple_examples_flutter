import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/operations_enums.dart';
import '../widgets/base_button.dart';
import '../widgets/text_field_calculator.dart';
import '../widgets/zero_button.dart';

/// Calculator based in iOS calculator interface
///
/// TODO Features:
///
/// * LandScape mode
/// * State management [Provider or Riverpod]
/// * Testing
///
class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  late TextEditingController _controller;

  final ValueNotifier<Operations?> _currentOperation = ValueNotifier(null);

  /// 100 - 25 = 75
  /// [_value] [_operationSelected] [_operator] = [_product]
  double _value = 0;
  Operations? _operationSelected;
  double _operator = 0;
  double _product = 0;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: '0');
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    // change color of status bar to white
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemStatusBarContrastEnforced: false,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  ///
  /// Method used to insert digit into text field
  /// [0-9] and [,]
  ///
  void _insertValue(String digit) {
    if (_currentOperation.value != null) _controller.text = '0';
    if (_controller.text == '0') {
      digit == ',' ? _controller.text = '0$digit' : _controller.text = digit;
      _saveSelectedOperator();
      return;
    }

    if (RegExp(r'\d').allMatches(_controller.text).length == 9) {
      return;
    }
    _controller.text += digit;

    final intValue = _controller.text.split(',').first.replaceAll('.', '');

    final newValue = intValue.replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (match) => '${match[1]}.',
    );

    if (_controller.text.contains(',')) {
      _controller.text = '$newValue,${_controller.text.split(',').last}';
      _saveSelectedOperator();
      return;
    }
    _controller.text = newValue;
    _saveSelectedOperator();
  }

  ///
  /// Method used to save in local value to operate
  ///
  void _saveSelectedOperator() {
    _operator =
        double.parse(_controller.text.replaceAll('.', '').replaceAll(',', '.'));
    _currentOperation.value = null;
  }

  ///
  /// Method used to save in local the operation selected
  /// [+, -, x, ÷]
  ///
  void _onPressOperation(Operations operation) {
    _value =
        double.parse(_controller.text.replaceAll('.', '').replaceAll(',', '.'));
    _currentOperation.value = operation;
    _operationSelected = operation;
    _operator =
        double.parse(_controller.text.replaceAll('.', '').replaceAll(',', '.'));
  }

  ///
  /// Method used to calculate the operation selected
  ///
  void _calculate() {
    switch (_currentOperation.value ?? _operationSelected) {
      case Operations.add:
        _product = _value + _operator;
        break;
      case Operations.subtract:
        _product = _value - _operator;
        break;
      case Operations.multiply:
        _product = _value * _operator;
        break;
      case Operations.divide:
        _product = _value / _operator;
        break;
      default:
    }
    _calculatorCases(double.parse(_product.toString()));
    _currentOperation.value = null;
    _value = _product;
  }

  ///
  /// Method used to review cases of calculator and parse to human view
  ///
  void _calculatorCases(double value) {
    final standardLength = value.toStringAsFixed(7);
    // Case 0: 0.0000000
    if (double.tryParse(standardLength) == 0) {
      _controller.text = '0';
      return;
    }
    // Case 1: 0.0000001
    if (standardLength.startsWith('0.')) {
      final decimals = standardLength.length < 9
          ? standardLength
          : standardLength.substring(0, 9);
      _controller.text =
          decimals.replaceAll(RegExp(r'0*$'), '').replaceAll('.', ',');
      return;
    }
    // Case 2: 123456789.1929219
    if (standardLength.split('.').first.length <= 9) {
      _parseToStandard(standardLength.substring(0, 9));
      return;
    }

    //convert to exponential notation
    _controller.text = value.toStringAsExponential(2);
  }

  /// Method used to parse to human view
  void _parseToStandard(String value) {
    final intValue = value.split('.').first;
    final newValue = intValue.replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (match) => '${match[1]}.',
    );
    final valueParsed = ('$newValue,${value.toString().split('.').last}')
        .replaceAll(RegExp(r'0*$'), '');
    _controller.text = valueParsed.endsWith(',')
        ? valueParsed.substring(0, valueParsed.length - 1)
        : valueParsed;
  }

  ///
  /// Method used to invert amount
  /// if amount is positive, convert to negative
  /// if amount is negative, convert to positive
  ///
  void _invertAmount() {
    if (_controller.text.startsWith('-')) {
      _controller.text = _controller.text.substring(1);
      _saveSelectedOperator();
      return;
    }
    _controller.text = '-${_controller.text}';
    _saveSelectedOperator();
  }

  ///
  /// Method used to get percentage of current amount
  ///
  void _getPercentage() {
    final currentValue =
        double.parse(_controller.text.replaceAll('.', '').replaceAll(',', '.'));
    final value = currentValue / 100;
    _calculatorCases(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CupertinoColors.black,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 450, maxHeight: 800),
          child: LayoutBuilder(
              builder: (_, constraints) => SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 5),
                      child: Column(
                        children: [
                          const Spacer(),
                          TextFieldCalculator(controller: _controller),
                          const SizedBox(height: 12),
                          //Buttons
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ValueListenableBuilder(
                                valueListenable: _controller,
                                builder: (_, value, __) => BaseButton(
                                  label: value.text == '0' ? 'AC' : 'C',
                                  onTap: () {
                                    _controller.text = '0';
                                    _currentOperation.value = null;
                                    _value = 0;
                                    _operator = 0;
                                    _product = 0;
                                  },
                                  backgroundColor: const Color(0xFFD4D4D2),
                                  labelColor: CupertinoColors.black,
                                  layoutSize: constraints.maxWidth,
                                ),
                              ),
                              BaseButton(
                                label: '+/-',
                                onTap: _invertAmount,
                                backgroundColor: const Color(0xFFD4D4D2),
                                labelColor: CupertinoColors.black,
                                layoutSize: constraints.maxWidth,
                              ),
                              BaseButton(
                                label: '%',
                                onTap: _getPercentage,
                                backgroundColor: const Color(0xFFD4D4D2),
                                labelColor: CupertinoColors.black,
                                layoutSize: constraints.maxWidth,
                              ),
                              ValueListenableBuilder(
                                valueListenable: _currentOperation,
                                builder: (_, currentOperation, __) {
                                  return BaseButton(
                                    label: Operations.divide.label,
                                    onTap: () =>
                                        _onPressOperation(Operations.divide),
                                    isActive:
                                        currentOperation == Operations.divide,
                                    layoutSize: constraints.maxWidth,
                                  );
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              BaseButton(
                                label: '7',
                                onTap: () => _insertValue('7'),
                                backgroundColor: const Color(0xFF505050),
                                labelColor: CupertinoColors.white,
                                layoutSize: constraints.maxWidth,
                              ),
                              BaseButton(
                                label: '8',
                                onTap: () => _insertValue('8'),
                                backgroundColor: const Color(0xFF505050),
                                labelColor: CupertinoColors.white,
                                layoutSize: constraints.maxWidth,
                              ),
                              BaseButton(
                                label: '9',
                                onTap: () => _insertValue('9'),
                                backgroundColor: const Color(0xFF505050),
                                labelColor: CupertinoColors.white,
                                layoutSize: constraints.maxWidth,
                              ),
                              ValueListenableBuilder(
                                valueListenable: _currentOperation,
                                builder: (_, currentOperation, __) {
                                  return BaseButton(
                                    label: Operations.multiply.label,
                                    onTap: () =>
                                        _onPressOperation(Operations.multiply),
                                    isActive:
                                        currentOperation == Operations.multiply,
                                    layoutSize: constraints.maxWidth,
                                  );
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              BaseButton(
                                label: '4',
                                onTap: () => _insertValue('4'),
                                backgroundColor: const Color(0xFF505050),
                                labelColor: CupertinoColors.white,
                                layoutSize: constraints.maxWidth,
                              ),
                              BaseButton(
                                label: '5',
                                onTap: () => _insertValue('5'),
                                backgroundColor: const Color(0xFF505050),
                                labelColor: CupertinoColors.white,
                                layoutSize: constraints.maxWidth,
                              ),
                              BaseButton(
                                label: '6',
                                onTap: () => _insertValue('6'),
                                backgroundColor: const Color(0xFF505050),
                                labelColor: CupertinoColors.white,
                                layoutSize: constraints.maxWidth,
                              ),
                              ValueListenableBuilder(
                                valueListenable: _currentOperation,
                                builder: (_, currentOperation, __) {
                                  return BaseButton(
                                    label: Operations.subtract.label,
                                    onTap: () =>
                                        _onPressOperation(Operations.subtract),
                                    isActive:
                                        currentOperation == Operations.subtract,
                                    layoutSize: constraints.maxWidth,
                                  );
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              BaseButton(
                                label: '1',
                                onTap: () => _insertValue('1'),
                                backgroundColor: const Color(0xFF505050),
                                labelColor: CupertinoColors.white,
                                layoutSize: constraints.maxWidth,
                              ),
                              BaseButton(
                                label: '2',
                                onTap: () => _insertValue('2'),
                                backgroundColor: const Color(0xFF505050),
                                labelColor: CupertinoColors.white,
                                layoutSize: constraints.maxWidth,
                              ),
                              BaseButton(
                                label: '3',
                                onTap: () => _insertValue('3'),
                                backgroundColor: const Color(0xFF505050),
                                labelColor: CupertinoColors.white,
                                layoutSize: constraints.maxWidth,
                              ),
                              ValueListenableBuilder(
                                valueListenable: _currentOperation,
                                builder: (_, currentOperation, __) {
                                  return BaseButton(
                                    label: Operations.add.label,
                                    onTap: () =>
                                        _onPressOperation(Operations.add),
                                    isActive:
                                        currentOperation == Operations.add,
                                    layoutSize: constraints.maxWidth,
                                  );
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ZeroButton(
                                label: '0',
                                onTap: () => _insertValue('0'),
                                backgroundColor: const Color(0xFF505050),
                                labelColor: CupertinoColors.white,
                                layoutSize: constraints.maxWidth,
                              ),
                              BaseButton(
                                label: ',',
                                onTap: () {
                                  if (_controller.text.contains(',')) return;
                                  _insertValue(',');
                                },
                                backgroundColor: const Color(0xFF505050),
                                labelColor: CupertinoColors.white,
                                layoutSize: constraints.maxWidth,
                              ),
                              BaseButton(
                                label: '=',
                                onTap: _calculate,
                                layoutSize: constraints.maxWidth,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )),
        ),
      ),
    );
  }
}
