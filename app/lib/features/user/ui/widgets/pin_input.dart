import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PinInput extends StatefulWidget {
  final Function(String) onCompleted;
  final Function(String)? onChanged;
  final int pinLength;
  final double boxSize;
  final Color? activeColor;
  final Color? inactiveColor;
  final Color? errorColor;
  final TextStyle? textStyle;
  final bool obscureText;
  final bool autofocus;

  const PinInput({
    super.key,
    required this.onCompleted,
    this.onChanged,
    this.pinLength = 6,
    this.boxSize = 50.0,
    this.activeColor,
    this.inactiveColor,
    this.errorColor,
    this.textStyle,
    this.obscureText = false,
    this.autofocus = true,
  });

  @override
  State<PinInput> createState() => _PinInputState();

  // Add these static methods to access private state methods
  static void clearPin(GlobalKey<State<PinInput>> key) {
    (key.currentState as _PinInputState?)?.clearPin();
  }

  static void showError(GlobalKey<State<PinInput>> key) {
    (key.currentState as _PinInputState?)?.showError();
  }
}

class _PinInputState extends State<PinInput> {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;
  String _pin = '';
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      widget.pinLength,
      (index) => TextEditingController(),
    );
    _focusNodes = List.generate(widget.pinLength, (index) => FocusNode());

    // Autofocus on first field
    if (widget.autofocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _focusNodes[0].requestFocus();
        }
      });
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _onChanged(String value, int index) {
    setState(() {
      _hasError = false;
    });

    if (value.isNotEmpty) {
      // Move to next field
      if (index < widget.pinLength - 1) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
      }
    }

    _updatePin();
  }

  void _onBackspace(int index) {
    if (_controllers[index].text.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  void _updatePin() {
    _pin = _controllers.map((controller) => controller.text).join();

    if (widget.onChanged != null) {
      widget.onChanged!(_pin);
    }

    if (_pin.length == widget.pinLength) {
      widget.onCompleted(_pin);
    }
  }

  void clearPin() {
    setState(() {
      for (final controller in _controllers) {
        controller.clear();
      }
      _pin = '';
      _hasError = false;
    });
    if (mounted) {
      _focusNodes[0].requestFocus();
    }
  }

  void showError() {
    setState(() {
      _hasError = true;
    });
  }

  Color _getBorderColor(int index) {
    if (_hasError) {
      return widget.errorColor ?? Colors.red;
    }
    if (_focusNodes[index].hasFocus) {
      return widget.activeColor ?? Theme.of(context).colorScheme.primary;
    }
    return widget.inactiveColor ?? Colors.grey.shade600;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List.generate(
        widget.pinLength,
        (index) => Container(
          width: widget.boxSize,
          height: widget.boxSize,
          decoration: BoxDecoration(
            border: Border.all(color: _getBorderColor(index)),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: KeyboardListener(
            focusNode: FocusNode(),
            onKeyEvent: (event) {
              if (event is KeyDownEvent &&
                  event.logicalKey == LogicalKeyboardKey.backspace) {
                _onBackspace(index);
              }
            },
            child: TextField(
              controller: _controllers[index],
              focusNode: _focusNodes[index],
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              obscureText: widget.obscureText,
              maxLength: 1,
              style:
                  widget.textStyle ??
                  const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(1),
              ],
              decoration: const InputDecoration(
                border: InputBorder.none,
                counterText: '',
                contentPadding: EdgeInsets.zero,
              ),
              onChanged: (value) => _onChanged(value, index),
            ),
          ),
        ),
      ),
    );
  }
}
