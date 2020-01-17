import Flutter
import UIKit
import Branch

public class SwiftFlutterBranchIoPlugin: NSObject, FlutterPlugin, FlutterStreamHandler {
    private var eventSink: FlutterEventSink?
    private var generatedLinkSink: FlutterEventSink?
    
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter_branch_io/message", binaryMessenger: registrar.messenger())
    let generatedLinkChannel = FlutterEventChannel(name: "flutter_branch_io/generated_link", binaryMessenger: registrar.messenger())
    
    guard let controller = UIApplication.shared.delegate!.window!!.rootViewController! as? FlutterViewController else {
        fatalError("rootViewController cannot be casted to FlutterViewController")
    }
    
    let eventChannel = FlutterEventChannel(name: "flutter_branch_io/event", binaryMessenger: registrar.messenger())

    let instance = SwiftFlutterBranchIoPlugin()
    generatedLinkChannel.setStreamHandler(instance)
    eventChannel.setStreamHandler(instance)
    registrar.addMethodCallDelegate(instance, channel: channel)
    
  }
    
    private func initBranchIO(branchKey: String) {
        Branch.setBranchKey(branchKey)
        Branch.getInstance().initSession() { (params, error) in
            // do stuff with deep link data (nav to page, display content, etc)
            print(params as? [String: AnyObject] ?? {})
            if (self.eventSink != nil) {
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: params!, options: .prettyPrinted)
                    let jsonString = String(data: jsonData, encoding: String.Encoding.utf8)
                    self.eventSink!(jsonString)
                } catch {
                    print("BRANCH IO FLUTTER IOS ERROR")
                    print(error)
                }
            } else {
                print("Branch IO eventSink is nil")
            }
        }
    }
    
  public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
      self.generatedLinkSink = events
      self.eventSink = events
      return nil
  }
    
  public func onCancel(withArguments arguments: Any?) -> FlutterError? {
      self.generatedLinkSink = nil
      self.eventSink = nil
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
        lp.channel = lpChannel as? String
    }
    if (lpFeature != nil) {
        lp.feature = lpFeature as? String
    }
    if (lpCampaign != nil) {
        lp.campaign = lpCampaign as? String
    }
    if (lpStage != nil) {
        lp.stage = lpStage as? String
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
    
  private func trackContent(buoJson: String, result: @escaping FlutterResult) {
    let buo: BranchUniversalObject? = convertStringToBUO(text: buoJson)
    if (buo == nil) { return }
    BranchEvent.standardEvent(.viewItem, withContentItem: buo!).logEvent()
    result("Success Log Event")
  }
    
  private func setUserIdentity(userId:String) {
    Branch.getInstance().setIdentity(userId)
  }
    
  private func clearUserIdentity() {
    Branch.getInstance().logout()
  }
    
  private func getLatestParam(result: @escaping FlutterResult) {
    let latestParams = Branch.getInstance().getLatestReferringParams()
    result(latestParams)
  }
    
  private func getFirstParam(result: @escaping FlutterResult) {
    let firstParams = Branch.getInstance().getFirstReferringParams()
    result(firstParams)
  }
    
  private func openUrl(url: String, result: @escaping FlutterResult) {
    Branch.getInstance().handleDeepLink(withNewSession: URL.init(string: url))
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    let args = call.arguments as? [String:Any?]
    switch (call.method) {
        case "initBranchIO":
            let branchKey = args!["branchKey"]! as! String
            initBranchIO(branchKey: branchKey)
            break
        case "generateLink":
            generateLink(call: call, result: result)
            break
        case "listOnGoogleSearch":
            listOnGoogleSearch(call: call, result: result)
            break
        case "trackContent":
            let buoJson = args?["buoJson"] as! String
            trackContent(buoJson: buoJson, result: result)
            break
        case "setUserIdentity":
            let userId = args?["userId"] as! String
            setUserIdentity(userId: userId)
            break
        case "clearUserIdentity":
            clearUserIdentity()
            break
        case "getLatestParam":
            getLatestParam(result: result)
            break
        case "getFirstParam":
            getFirstParam(result: result)
            break
        case "openUrl":
            let url = args!["url"]! as! String
            openUrl(url: url, result: result)
            break
        
        default:
            result("iOS " + UIDevice.current.systemVersion)
    }
  }
}
