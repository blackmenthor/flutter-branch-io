import UIKit
import Flutter
import Branch

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate, FlutterStreamHandler {
    private var eventSink: FlutterEventSink?
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?
        ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        guard let controller = window?.rootViewController as? FlutterViewController else {
            fatalError("rootViewController cannot be casted to FlutterViewController")
        }
        
        let eventChannel = FlutterEventChannel(name: "flutter_branch_io/event", binaryMessenger: controller)

        eventChannel.setStreamHandler(self)
        
        // if you are using the TEST key
        // WARNING: DELETE THIS LINE FOR PRODUCTION USE
        Branch.setUseTestBranchKey(true)
        // listener for Branch Deep Link data
        Branch.getInstance().initSession(launchOptions: launchOptions) { (params, error) in
            // do stuff with deep link data (nav to page, display content, etc)
            print(params as? [String: AnyObject] ?? {})
            if (self.eventSink != nil) {
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
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
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    override func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        Branch.getInstance().application(app, open: url, options: options)
        return true
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        // handler for Universal Links
        Branch.getInstance().continue(userActivity)
        return true
    }
    
    override func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // handler for Push Notifications
        Branch.getInstance().handlePushNotification(userInfo)
    }
    
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = events
        return nil
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        self.eventSink = nil
        return nil
    }
}
