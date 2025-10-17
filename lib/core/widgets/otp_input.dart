import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  void _handlePaste(String pastedText) {
    // ✅ Clean and limit to length
    final cleanText = pastedText.replaceAll(
      RegExp(r'\D'),
      '',
    ); // remove non-digits
    final limitedText = cleanText.substring(0, widget.length);

    for (int i = 0; i < widget.length; i++) {
      _controllers[i].text = i < limitedText.length ? limitedText[i] : '';
    }

    if (limitedText.length == widget.length) {
      _focusNodes.last.unfocus();
      widget.onCompleted?.call(limitedText);
    } else {
      _focusNodes[limitedText.length].requestFocus();
      widget.onCompleted?.call(limitedText);
    }
  }

  void _onChanged(String value, int index) {
    // ✅ Detect paste manually from clipboard when more than 1 char
    if (value.length > 1) {
      _handlePaste(value);
      return;
    }

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
    return Row(
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
            onTap: () async {
              // Detect paste directly from clipboard on tap (optional)
              final data = await Clipboard.getData('text/plain');
              if (data != null &&
                  data.text != null &&
                  data.text!.trim().length > 1) {
                _handlePaste(data.text!.trim());
              }
            },
          ),
        );
      }),
    );
  }
}
