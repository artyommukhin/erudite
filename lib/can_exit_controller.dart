import 'dart:js_interop';

import 'package:flutter/foundation.dart';
import 'package:web/web.dart';

class CanExitController extends ValueNotifier<bool> {
  CanExitController() : super(true) {
    addListener(() {
      if (value) {
        window.removeEventListener('beforeunload', _preventExit);
      } else {
        window.addEventListener('beforeunload', _preventExit);
      }
    });
  }

  /// https://developer.mozilla.org/en-US/docs/Web/API/Window/beforeunload_event
  final _preventExit = (BeforeUnloadEvent event) {
    event.preventDefault();
    event.returnValue = 'true';
  }.toJS;

  void allow() => value = true;

  void forbid() => value = false;
}
