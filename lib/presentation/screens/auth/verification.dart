import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sanam_laundry/core/index.dart';
import 'package:sanam_laundry/data/index.dart';
import 'package:sanam_laundry/presentation/index.dart';
import 'package:sanam_laundry/providers/auth.dart';

class Verification extends StatefulWidget {
  const Verification({super.key});

  @override
  State<Verification> createState() => _VerificationState();
}

class _VerificationState extends State<Verification> {
  final _formKey = GlobalKey<FormState>();
  String _otpCode = "";
  final AuthRepository _authRepository = AuthRepository();

  bool _isOtpComplete = false;
  bool loading = false;

  int _secondsRemaining = 60;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _secondsRemaining = 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining == 0) {
        timer.cancel();
      } else {
        setState(() => _secondsRemaining--);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_isOtpComplete) return;
    setState(() => loading = true);
    final user = await _authRepository.verifyOtp(
      phone: context.getParam<String>('phone') ?? '',
      otp: _otpCode,
      deviceToken: await FirebaseMessaging.instance.getToken() ?? '',
      // device_type:Testing Tool
      // udid:123456789
      // device_brand:Postman
      // device_os:Linux
      // app_version:1.0.0
    );
    if (!mounted) return;
    setState(() => loading = false);
    final isFromLogin = context.getParam<bool>('isFromLogin') ?? false;
    if (user != null) {
      context.read<AuthProvider>().login(context, user);
      if (!isFromLogin) {
        AppDialog.show(
          context,
          title: Auth.okayAllSet,
          imagePath: AppAssets.allSet,
          borderColor: AppColors.primary,
          borderWidth: 4,
          dismissible: false,
          borderRadius: Dimens.radiusL,
          imageSize: 150,
          content: AppText(
            maxLines: 3,
            textAlign: TextAlign.center,
            Auth.soonYouWillRecieve,
          ),
          primaryButtonText: Auth.letsExploreApp,
          onPrimaryPressed: () => context.replacePage(AppRoutes.home),
          backgroundColor: AppColors.lightWhite,
          crossAxisAlignment: CrossAxisAlignment.center,
          insetPadding: EdgeInsets.all(Dimens.spacingXXL),
        );
      } else {
        AppDialog.show(
          context,
          title: Common.successfullyLoggedIn,
          imagePath: AppAssets.rightTick,
          spacing: Dimens.spacingMSmall,
          dismissible: false,
          content: AppText(
            maxLines: 3,

            textAlign: TextAlign.center,
            Auth.gladToHadYouBack,
          ),
          crossAxisAlignment: CrossAxisAlignment.center,
          insetPadding: EdgeInsets.all(Dimens.spacingXXL),
        );
        Future.delayed(const Duration(seconds: 3), () {
          if (!mounted) return;
          context.replacePage(AppRoutes.home);
        });
      }
    }
  }

  void _onOtpCompleted(String code) {
    final isComplete = code.length == 4;
    setState(() {
      _otpCode = code;
      _isOtpComplete = isComplete;
    });
    if (isComplete) {
      FocusScope.of(context).unfocus();
    }
  }

  void _onResendPressed() async {
    if (_secondsRemaining == 0) {
      _startTimer();
      await _authRepository.login(
        phone: context.getParam<String>('phone') ?? '',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // final phone = context.getParam<String>('phone') ?? '';

    return AuthWrapper(
      formKey: _formKey,
      height: true,
      title: Common.enterOtp,
      subtitle: Common.enterVerificationCodeYou,
      buttonText: Common.continue_,
      isLoading: loading,
      bottomButtonText: _secondsRemaining == 0 ? Common.reSendCode : "",
      showBackButton: true,
      bottomButtonPress: _onResendPressed,
      isButtonEnabled: _isOtpComplete,
      onSubmit: _submit,
      child: Column(
        spacing: Dimens.spacingMSmall,
        children: [
          AppOtpInput(length: 4, onCompleted: _onOtpCompleted),
          if (_secondsRemaining > 0)
            AppText(
              Common.youCanResendTheCode,
              params: {"second": '$_secondsRemaining'},
            ),
          //
        ],
      ),
    );
  }
}
