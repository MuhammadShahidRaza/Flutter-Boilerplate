import 'package:flutter/material.dart';
import 'package:sanam_laundry/core/index.dart';
import 'package:sanam_laundry/core/widgets/otp_input.dart';
import 'package:sanam_laundry/presentation/index.dart';

class Verification extends StatefulWidget {
  const Verification({super.key});

  @override
  State<Verification> createState() => _VerificationState();
}

class _VerificationState extends State<Verification> {
  final _formKey = GlobalKey<FormState>();
  String _otpCode = "";
  bool _isOtpComplete = false;

  void _submit() {
    if (!_isOtpComplete) return;

    if (_formKey.currentState?.validate() ?? false) {
      // Handle OTP verification here
      print("Verifying OTP: $_otpCode");
      // context.replacePage(AppRoutes.home);
    }
  }

  void _onOtpCompleted(String code) {
    setState(() {
      _otpCode = code;
      _isOtpComplete = code.length == 4; // dynamically match OTP length
    });
  }

  @override
  Widget build(BuildContext context) {
    return AuthWrapper(
      formKey: _formKey,
      height: true,
      title: Common.enterOtp,
      subtitle: Common.enterVerificationCodeYou,
      buttonText: Common.continue_,
      bottomButtonText: Common.reSendCode,
      bottomButtonPress: () {
        print("Resend code tapped");
      },
      isButtonEnabled: _isOtpComplete,
      onSubmit: _submit,
      child: Column(
        spacing: Dimens.spacingMSmall,
        children: [
          AppOtpInput(length: 4, onCompleted: _onOtpCompleted),
          AppText(Common.youCanResendTheCode, params: {"second": "25"}),
          //
        ],
      ),
    );
  }
}
