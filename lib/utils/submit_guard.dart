import 'dart:async';

import 'package:flutter/material.dart';

mixin SubmitGuard<T extends StatefulWidget> on State<T> {
  var submitLocked = false;

  Future<void> runExclusive(FutureOr<void> Function() action) async {
    if (submitLocked) return;
    setState(() => submitLocked = true);
    try {
      await action();
    } finally {
      if (mounted) setState(() => submitLocked = false);
    }
  }
}
