import 'package:flutter/material.dart';
import 'package:sanam_laundry/core/index.dart';

class AppOtpInput extends StatefulWidget {
  final int length;
  final void Function(String code)? onCompleted;

  const AppOtpInput({super.key, this.length = 4, this.onCompleted});

  @override
  State<AppOtpInput> createState() => _AppOtpInputState();
}

class _AppOtpInputState extends State<AppOtpInput> {
  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(widget.length, (_) => TextEditingController());
    _focusNodes = List.generate(widget.length, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _onChanged(String value, int index) {
    // ✅ Move focus forward or backward
    if (value.isNotEmpty && index < widget.length - 1) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }

    // ✅ Combine and trigger callback
    final code = _controllers.map((e) => e.text).join();
    widget.onCompleted?.call(code);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(widget.length, (index) {
          return SizedBox(
            width: 60,
            child: AppInput(
              controller: _controllers[index],
              focusNode: _focusNodes[index],
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              maxLength: 1,
              style: context.textTheme.titleLarge?.copyWith(letterSpacing: 2),
              counterText: "",
              onChanged: (value) => _onChanged(value, index),
            ),
          );
        }),
      ),
    );
  }
}
