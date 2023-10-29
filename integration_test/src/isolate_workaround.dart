import 'dart:async';

import 'package:flutter_driver/flutter_driver.dart';

class IsolatesWorkaround {
  IsolatesWorkaround(this._driver, {this.log = false});

  final FlutterDriver _driver;
  final bool log;

  StreamSubscription? _streamSubscription;

  /// workaround for isolates
  /// https://github.com/flutter/flutter/issues/24703
  Future<void> resumeIsolates() async {
    final vm = await _driver.serviceClient.getVM();
    // // unpause any paused isolated
    for (final isolateRef in vm.isolates!) {
      final isolate = await _driver.serviceClient.getIsolate(isolateRef.id!);

      if (isolate.pauseEvent?.kind == 'Pause') {
        await _driver.serviceClient.resume(isolate.id!);
        if (log) {
          print('Resuming isolate: ${isolate.number}:${isolate.name}');
        }
      }
    }
    if (_streamSubscription != null) {
      return;
    }
    _streamSubscription = _driver.serviceClient.onIsolateEvent
        .asBroadcastStream()
        .listen((event) async {
      // I don't get any events when running this on my system with my app
      // so I can't verify that this section works.
      if (event.kind != 'IsolateRunnable') {
        return;
      }
      final isolate =
          await _driver.serviceClient.getIsolate(event.isolate!.id!);
      if (isolate.pauseEvent?.kind == 'Pause') {
        await _driver.serviceClient.resume(isolate.id!);
        if (log) {
          print('Resuming isolate: ${isolate.number}:${isolate.name}');
        }
      }
    });
  }

  void dispose() {
    _streamSubscription?.cancel();
  }
}
