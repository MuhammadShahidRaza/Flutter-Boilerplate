// ignore_for_file: invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

extension SafeSetState<T extends StatefulWidget> on State<T> {
  void safeSetState(VoidCallback fn) {
    if (!mounted) return;
    if (!SchedulerBinding.instance.hasScheduledFrame) {
      SchedulerBinding.instance.scheduleFrameCallback((_) => safeSetState(fn));
      return;
    }
    setState(fn);
  }
}
