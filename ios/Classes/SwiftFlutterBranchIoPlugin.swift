import Flutter
import UIKit
import Branch

public class SwiftFlutterBranchIoPlugin: NSObject, FlutterPlugin, FlutterStreamHandler {
    
    private var generatedLinkSink: FlutterEventSink?
    
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter_branch_io/message", binaryMessenger: registrar.messenger())
    let generatedLinkChannel = FlutterEventChannel(name: "flutter_branch_io/generated_link", binaryMessenger: registrar.messenger())
    
    let instance = SwiftFlutterBranchIoPlugin()
    generatedLinkChannel.setStreamHandler(instance)
    registrar.addMethodCallDelegate(instance, channel: channel)
    
  }
    
  public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
      self.generatedLinkSink = events
      return nil
  }
    
  public func onCancel(withArguments arguments: Any?) -> FlutterError? {
      self.generatedLinkSink = nil
      return nil
  }
    
  func convertToDictionary(text: String) -> [String: Any]? {
    if let data = text.data(using: .utf8) {
      do {
        return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
      } catch {
        print(error.localizedDescription)
      }
   }
   return nil
  }
    
  func convertStringToBUO(text: String) -> BranchUniversalObject? {
    let dict: [String: Any]? = convertToDictionary(text: text)
    if (dict == nil) { return nil }
    let buo: BranchUniversalObject = BranchUniversalObject.init(dictionary: dict)
    return buo
  }

    private func sendUrlToSink(url: String) {
        if (self.generatedLinkSink != nil) {
            self.generatedLinkSink!(url)
        } else {
            print("Generated Link Sink is nil")
        }
    }
    
  private func generateLink(call: FlutterMethodCall, result: @escaping FlutterResult) {
    let args = call.arguments as? [String: Any?]
    let buoJson = args?["buoJson"] as? String?
    let lpChannel = args?["lp_channel"] as? String?
    let lpFeature = args?["lp_feature"] as? String?
    let lpCampaign = args?["lp_campaign"] as? String?
    let lpStage = args?["lp_stage"] as? String?
    let lpParams = args?["lp_control_params"] as? [String: Any?]?
    
    let buo: BranchUniversalObject? = convertStringToBUO(text: buoJson!!)
    
    let lp: BranchLinkProperties = BranchLinkProperties()
    if (lpChannel != nil) {
        lp.channel = lpChannel as! String
    }
    if (lpFeature != nil) {
        lp.feature = lpFeature as! String
    }
    if (lpCampaign != nil) {
        lp.campaign = lpCampaign as! String
    }
    if (lpStage != nil) {
        lp.stage = lpStage as! String
    }
    if (lpParams != nil) {
        for param in lpParams!! {
            lp.addControlParam(param.key, withValue: param.value as? String)
        }
    }
    
    buo?.getShortUrl(with: lp) { (url, error) in
        self.sendUrlToSink(url: url!)
    }
    result("Success generating Link!")
    
  }
    
  private func listOnGoogleSearch(call: FlutterMethodCall, result: @escaping FlutterResult) {
    result("Cannot list on Google Search on iOS")
  }
    
  private func trackContent(call: FlutterMethodCall, result: @escaping FlutterResult) {
    let args = call.arguments as? [String: Any?]
    let buoJson = args?["buoJson"] as! String?
    
    let buo: BranchUniversalObject? = convertStringToBUO(text: buoJson!)
    if (buo == nil) { return }
    BranchEvent.standardEvent(.viewItem, withContentItem: buo!).logEvent()
    result("Success Log Event")
  }
    
  private func setUserIdentity(call: FlutterMethodCall, result: @escaping FlutterResult) {
    let args = call.arguments as? [String: Any?]
    let userId = args?["userId"] as! String?
    Branch.getInstance()?.setIdentity(userId)
  }
    
  private func clearUserIdentity(call: FlutterMethodCall, result: @escaping FlutterResult) {
    Branch.getInstance().logout()
  }
    
  private func getLatestParam(call: FlutterMethodCall, result: @escaping FlutterResult) {
    let latestParams = Branch.getInstance()?.getLatestReferringParams()
    result(latestParams)
  }
    
  private func getFirstParam(call: FlutterMethodCall, result: @escaping FlutterResult) {
    let firstParams = Branch.getInstance()?.getFirstReferringParams()
    result(firstParams)
  }
    
  private func openUrl(call: FlutterMethodCall, result: @escaping FlutterResult) {
    let args = call.arguments as! [String:Any]
    let url = args["url"]! as! String

    Branch.getInstance()?.handleDeepLink(withNewSession: URL.init(string: url))
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch (call.method) {
        case "generateLink":
            generateLink(call: call, result: result)
            break
        case "listOnGoogleSearch":
            listOnGoogleSearch(call: call, result: result)
            break
        case "trackContent":
            trackContent(call: call, result: result)
            break
        case "setUserIdentity":
            setUserIdentity(call: call
                , result: result)
            break
        case "clearUserIdentity":
            clearUserIdentity(call: call
                , result: result)
            break
        case "getLatestParam":
            getLatestParam(call: call
                , result: result)
            break
        case "getFirstParam":
            getFirstParam(call: call
                , result: result)
            break
        case "openUrl":
            openUrl(call: call, result: result)
            break
        default:
            result("iOS " + UIDevice.current.systemVersion)
    }
  }
}
