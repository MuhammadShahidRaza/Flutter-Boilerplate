import 'package:flutter/material.dart';

extension FormKeyValidator on GlobalKey<FormState> {
  bool get isValid => currentState?.validate() ?? false;
}
