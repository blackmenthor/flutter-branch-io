import 'dart:async';

import 'package:flutter/services.dart';

class FlutterBranchIoPlugin {
  static const MethodChannel _messageChannel = const MethodChannel('flutter_branch_io/message');
  static const EventChannel _eventChannel = const EventChannel('flutter_branch_io/event');
  static const EventChannel _onStartChannel = const EventChannel('flutter_branch_io/on_start');

  static Stream<String> mainStream;
  static Stream<String> onStartStream;

  static void setupBranchIO() {
    _messageChannel.invokeMethod('initBranchIO');
  }

  static Stream<String> listenToDeepLinkStream() {
    if ( mainStream == null ) mainStream = _eventChannel.receiveBroadcastStream().cast<String>();
    return mainStream;
  }

  static Stream<String> listenToOnStartStream() {
    if ( onStartStream == null ) onStartStream = _onStartChannel.receiveBroadcastStream().cast<String>();
    return onStartStream;
  }
}
