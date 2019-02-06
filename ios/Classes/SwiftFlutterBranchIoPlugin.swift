import Flutter
import UIKit
import Branch

public class SwiftFlutterBranchIoPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter_branch_io_plugin", binaryMessenger: registrar.messenger())
    let instance = SwiftFlutterBranchIoPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    result("iOS " + UIDevice.current.systemVersion)
  }
}
