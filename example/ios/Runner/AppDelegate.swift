import UIKit
import Flutter
import Branch

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
        ) -> Bool {
        // if you are using the TEST key
        // WARNING: DELETE THIS LINE FOR PRODUCTION USE
        Branch.setUseTestBranchKey(true)
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
}
