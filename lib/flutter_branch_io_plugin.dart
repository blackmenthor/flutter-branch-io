import 'dart:async';

import 'package:flutter/services.dart';

export 'package:flutter_branch_io_plugin/src/models/branch_universal_object.dart';
export 'package:flutter_branch_io_plugin/src/models/content_meta_data.dart';

class FlutterBranchIoPlugin {
  static const MethodChannel _messageChannel = const MethodChannel('flutter_branch_io/message');
  static const EventChannel _eventChannel = const EventChannel('flutter_branch_io/event');
  static const EventChannel _onStartChannel = const EventChannel('flutter_branch_io/on_start');

  static Stream<String> mainStream;
  static Stream<String> onStartStream;

  static void setupBranchIO() {
    _messageChannel.invokeMethod('initBranchIO');
  }

  static Future<String> getBUOJSON() async {
    try {
      return await _messageChannel.invokeMethod('getBUOJSON');
    } catch (e) {
      return e.toString();
    }
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
