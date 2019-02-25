import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_branch_io_plugin/flutter_branch_io_plugin.dart';

export 'package:flutter_branch_io_plugin/src/models/branch_universal_object.dart';
export 'package:flutter_branch_io_plugin/src/models/content_meta_data.dart';
export 'package:flutter_branch_io_plugin/src/models/branch_standard_event.dart';

class FlutterBranchIoPlugin {
  static const MethodChannel _messageChannel = const MethodChannel('flutter_branch_io/message');
  static const EventChannel _eventChannel = const EventChannel('flutter_branch_io/event');
  static const EventChannel _generatedLinkChannel = const EventChannel('flutter_branch_io/generated_link');

  static Stream<String> mainStream;
  static Stream<String> generatedLinkStream;

  static void setupBranchIO() {
    if (Platform.isAndroid) _messageChannel.invokeMethod('initBranchIO');
  }

  static void generateLink(
    FlutterBranchUniversalObject buo,
    {
      String lpChannel,
      String lpFeature,
      String lpCampaign,
      String lpStage,
      Map<String, dynamic> lpControlParams,
    }
  ) async {
    if (Platform.isAndroid) {
      Map<String, dynamic> _params = {};
      String buoJson = buo.toJson();
      _params['buoJson'] = buoJson;
      if (lpChannel != null) _params['lp_channel'] = lpChannel;
      if (lpFeature != null) _params['lp_feature'] = lpFeature;
      if (lpCampaign != null) _params['lp_campaign'] = lpCampaign;
      if (lpStage != null) _params['lp_stage'] = lpStage;
      if (lpControlParams != null)
        _params['lp_control_params'] = lpControlParams;

      _messageChannel.invokeMethod("generateLink", _params);
    }
  }

  static void listOnGoogleSearch(
      FlutterBranchUniversalObject buo,
      {
        String lpChannel,
        String lpFeature,
        String lpCampaign,
        String lpStage,
        Map<String, dynamic> lpControlParams,
      }
    ) async {
    if (Platform.isAndroid) {
      Map<String, dynamic> _params = {};
      String buoJson = buo.toJson();
      _params['buoJson'] = buoJson;
      if (lpChannel != null) _params['lp_channel'] = lpChannel;
      if (lpFeature != null) _params['lp_feature'] = lpFeature;
      if (lpCampaign != null) _params['lp_campaign'] = lpCampaign;
      if (lpStage != null) _params['lp_stage'] = lpStage;
      if (lpControlParams != null)
        _params['lp_control_params'] = lpControlParams;

      _messageChannel.invokeMethod("listOnGoogleSearch", _params);
    }
  }

  static void trackContent(
      FlutterBranchUniversalObject buo,
      String eventType
  ) {
    if (Platform.isAndroid) {
      Map<String, dynamic> _params = {};
      String buoJson = buo.toJson();
      _params['buoJson'] = buoJson;
      _params['eventType'] = eventType;

      _messageChannel.invokeMethod("trackContent", _params);
    }
  }

  static void setUserIdentity( String userId ) {
    if (Platform.isAndroid) {
      Map<String, dynamic> _params = {};
      _params["userId"] = userId;
      _messageChannel.invokeMethod("setUserIdentity", _params);
    }
  }

  static void clearUserIdentity( String userId ) {
    if (Platform.isAndroid) _messageChannel.invokeMethod("clearUserIdentity");
  }

  static Future<String> getLatestParam() async {
    if (Platform.isAndroid) {
      return await _messageChannel.invokeMethod('getLatestParam');
    }
    return "";
  }

  static Future<String> getFirstParam() async {
    if (Platform.isAndroid) {
      return await _messageChannel.invokeMethod('getFirstParam');
    }
    return "";
  }

  static Stream<String> listenToDeepLinkStream() {
    if ( mainStream == null ) mainStream = _eventChannel.receiveBroadcastStream().cast<String>();
    return mainStream;
  }

  static Stream<String> listenToGeneratedLinkStream() {
    if (Platform.isIOS) return Stream.empty();
    if ( generatedLinkStream == null ) generatedLinkStream = _generatedLinkChannel.receiveBroadcastStream().cast<String>();
    return generatedLinkStream;
  }
}
