import Branch
import Flutter
import UIKit

public class SwiftFlutterBranchIoPlugin: FlutterPluginAppLifeCycleDelegate, FlutterPlugin {
    static var eventHandler: EventStreamHandler?
    static var generatedLinkHandler: EventStreamHandler?

    public static func register(with registrar: FlutterPluginRegistrar) {
        let instance = SwiftFlutterBranchIoPlugin()
        let channel = FlutterMethodChannel(name: "flutter_branch_io/message", binaryMessenger: registrar.messenger())
        registrar.addMethodCallDelegate(instance, channel: channel)
        registrar.addApplicationDelegate(instance)

        let generatedLinkChannel = FlutterEventChannel(name: "flutter_branch_io/generated_link", binaryMessenger: registrar.messenger())
        generatedLinkHandler = EventStreamHandler()
        generatedLinkChannel.setStreamHandler(generatedLinkHandler)

        let eventChannel = FlutterEventChannel(name: "flutter_branch_io/event", binaryMessenger: registrar.messenger())
        eventHandler = EventStreamHandler()
        eventChannel.setStreamHandler(eventHandler)
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
        if dict == nil { return nil }
        let buo: BranchUniversalObject = BranchUniversalObject(dictionary: dict)
        return buo
    }

    private func sendUrlToSink(url: String) {
        if SwiftFlutterBranchIoPlugin.generatedLinkHandler?.eventSink != nil {
            SwiftFlutterBranchIoPlugin.generatedLinkHandler!.eventSink!(url)
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
        if lpChannel != nil {
            lp.channel = lpChannel as! String
        }
        if lpFeature != nil {
            lp.feature = lpFeature as! String
        }
        if lpCampaign != nil {
            lp.campaign = lpCampaign as! String
        }
        if lpStage != nil {
            lp.stage = lpStage as! String
        }
        if lpParams != nil {
            for param in lpParams!! {
                lp.addControlParam(param.key, withValue: param.value as? String)
            }
        }

        buo?.getShortUrl(with: lp) { url, _ in
            self.sendUrlToSink(url: url!)
        }
        result("Success generating Link!")
    }

    private func listOnGoogleSearch(call _: FlutterMethodCall, result: @escaping FlutterResult) {
        result("Cannot list on Google Search on iOS")
    }

    private func trackContent(call: FlutterMethodCall, result: @escaping FlutterResult) {
        let args = call.arguments as? [String: Any?]
        let buoJson = args?["buoJson"] as! String?

        let buo: BranchUniversalObject? = convertStringToBUO(text: buoJson!)
        if buo == nil { return }
        BranchEvent.standardEvent(.viewItem, withContentItem: buo!).logEvent()
        result("Success Log Event")
    }

    private func setUserIdentity(call: FlutterMethodCall, result _: @escaping FlutterResult) {
        let args = call.arguments as? [String: Any?]
        let userId = args?["userId"] as! String?
        Branch.getInstance()?.setIdentity(userId)
    }

    private func clearUserIdentity(call _: FlutterMethodCall, result _: @escaping FlutterResult) {
        Branch.getInstance()?.logout()
    }

    private func getLatestParam(call _: FlutterMethodCall, result: @escaping FlutterResult) {
        let latestParams = Branch.getInstance()?.getLatestReferringParams()
        result(latestParams)
    }

    private func getFirstParam(call _: FlutterMethodCall, result: @escaping FlutterResult) {
        let firstParams = Branch.getInstance()?.getFirstReferringParams()
        result(firstParams)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "generateLink":
            generateLink(call: call, result: result)
        case "listOnGoogleSearch":
            listOnGoogleSearch(call: call, result: result)
        case "trackContent":
            trackContent(call: call, result: result)
        case "setUserIdentity":
            setUserIdentity(call: call,
                            result: result)
        case "clearUserIdentity":
            clearUserIdentity(call: call,
                              result: result)
        case "getLatestParam":
            getLatestParam(call: call,
                           result: result)
        case "getFirstParam":
            getFirstParam(call: call,
                          result: result)
        default:
            result("iOS " + UIDevice.current.systemVersion)
        }
    }

    override public func application(
        _ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [AnyHashable: Any]
    ) -> Bool {
        Branch.getInstance()?.initSession(launchOptions: launchOptions) { params, error in
            // do stuff with deep link data (nav to page, display content, etc)
            print(params as? [String: AnyObject] ?? {})
            if SwiftFlutterBranchIoPlugin.eventHandler?.eventSink != nil {
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
                    let jsonString = String(data: jsonData, encoding: String.Encoding.utf8)
                    SwiftFlutterBranchIoPlugin.eventHandler?.eventSink!(jsonString)
                } catch {
                    print("BRANCH IO FLUTTER IOS ERROR")
                    print(error)
                }
            } else {
                print("Branch IO eventSink is nil")
            }
        }
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }


    override public func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        let branchHandled = Branch.getInstance()?.application(app, open: url, options: options) ?? false
        return branchHandled
    }

    @nonobjc override public func application(_ app: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler _: @escaping (UIBackgroundFetchResult) -> Void) {
        // handler for Push Notifications
        Branch.getInstance()?.handlePushNotification(userInfo)
    }

    public func application(_ app: UIApplication, continue userActivity: NSUserActivity, restorationHandler _: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        // handler for Universal Links
        let handledByBranch = Branch.getInstance()?.continue(userActivity) ?? false
        return handledByBranch
    }
}
